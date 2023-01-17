-module(loadBalance).
-export([startServers/0, stopServers/0, numberOfRunningFunctions/1, calcFun/3]).

%% ~~~~~ exported functions ~~~~~

startServers()->
	sup:start(),
	[supervisor:start_child(sup, []) || _Id<-lists:seq(1,3)],
	%supervisor:start_child(sup, []),
	%supervisor:start_child(sup, []),
	%supervisor:start_child(sup, []),
	ok.
	
stopServers()->
	[supervisor:terminate_child(sup,getServerPid(Id)) || Id<-lists:seq(1,3)],
	exit(whereis(sup), kill),
	ok.
	
numberOfRunningFunctions(Id)->
	server:numberOfRunningFunctions(Id).
	
calcFun(Pid, Fun, MsgRef)->
	{_,Id} = lists:min([{numberOfRunningFunctions(N),N} || N<-lists:seq(1,3)]),
	server:calcFun(Pid, Fun, MsgRef, Id),
	ok.
	
%% ~~~~~ internal functions ~~~~~
	
getServerPid(Id)->
	whereis(list_to_atom(string:concat("server",integer_to_list(Id)))).