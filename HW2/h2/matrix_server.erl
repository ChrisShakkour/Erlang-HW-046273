-module(matrix_server).
-export([start_server/0, shutdown/0, mult/2, get_version/0, explanation/0, server/0, multiplier/4, vec_mul/5]).

start_server()->
	spawn(sup,restarter,[]),
	ok.

server()->
	Version = version_1,
	receive
		{Pid, MsgRef, {multiple, Mat1, Mat2}}->
					spawn(?MODULE,multiplier,[Pid,MsgRef,Mat1,Mat2]),
					server();
		shutdown->  
				unregister(matrix_server),
				ok;
		{Pid, MsgRef, get_version}-> 
					Pid ! {MsgRef, Version},
					server();
		sw_upgrade -> ?MODULE:server();
		_ -> 		server()%to clean mailbox
	end.
	
multiplier(Pid,MsgRef,Mat1,Mat2)->
	{N,_K,M} = matrix:getSizes(Mat1,Mat2),%M1: N*K  M2: K*M
	Mat_ans = matrix:getZeroMat(N,M),
	[spawn(?MODULE, vec_mul, 
		[matrix:getRow(Mat1,Row_num), matrix:getCol(Mat2,Col_num),
		Row_num, Col_num,self()]) || 
		Row_num <- lists:seq(1,N) ,
		Col_num <- lists:seq(1,M) ],
	wait_for_all(0,N*M,Mat_ans,Pid, MsgRef).
	
wait_for_all(I,Max, Mat_ans, Pid, MsgRef)->
	receive
		{Val, Row_num, Col_num} when (I=/=(Max-1)) -> %not the last answer
				Mat_new = matrix:setElementMat(Row_num,Col_num,Mat_ans,Val),
				wait_for_all(I+1,Max, Mat_new, Pid, MsgRef);
		{Val, Row_num, Col_num} -> %last answer
				Pid ! {MsgRef,matrix:setElementMat(Row_num,Col_num,Mat_ans,Val)}
	end.
	
vec_mul(Row, Col,Row_num,Col_num,Pid)->
		Val = lists:sum([ X * Y || {X, Y} <- lists:zip(tuple_to_list(Row), tuple_to_list(Col)) ]),
		Pid ! {Val,Row_num,Col_num}. 

shutdown()->
	matrix_server ! shutdown.
	
mult(Mat1,Mat2)->
	MsgRef = make_ref(),
	matrix_server ! {self(), MsgRef, {multiple, Mat1, Mat2}},
	receive 
		{MsgRef, Mat} -> Mat
	end.
	
get_version() -> 
	MsgRef = make_ref(),
	matrix_server ! {self(), MsgRef, get_version},
	receive 
		{MsgRef, Version} ->  Version
	end.
		
explanation()-> { "to avoid the supervisor's termination after 2 updates" }.