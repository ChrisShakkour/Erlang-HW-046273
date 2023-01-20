-module (server).
-behaviour (gen_server).

-export ([start_link/0]).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([numberOfRunningFunctions/1, calcFun/4, processFun/4]).

init (_Args) -> 
	process_flag(trap_exit, true) ,
	{ok, 0}.

handle_call (numberOfRunningFunctions, _From, State) ->
	{reply, State, State}.

handle_cast ({From, Fun, MsgRef}, State) ->
	spawn_link(?MODULE, processFun, [From, Fun, MsgRef, self()]),
	{noreply,State+1};
handle_cast (finished, State) ->
	{noreply,State-1}.
	
handle_info (_Info, State) -> {noreply, State}.
terminate (_Reason, _State) -> ok.
code_change (_OldVsn, State, _Extra) -> {ok, State}.

start_link () ->
	Name = getFreeServer(),
	gen_server:start_link ({local, Name}, ?MODULE, [], []).
	
processFun(From, Fun, MsgRef, CPid)-> 
	try apply(Fun, []) of
		Res -> From ! {MsgRef, Res}
	catch  
		_TypeOfError:Reason -> From ! {crashed,Reason}
	end,
	gen_server:cast(CPid, finished),
	ok.

getServer(Id)->
	list_to_atom(string:concat("server",integer_to_list(Id))).

numberOfRunningFunctions(Id)->
	Name = getServer(Id),
	gen_server:call(Name,numberOfRunningFunctions).
	
calcFun(From, Fun, MsgRef, Id)->
	Name = getServer(Id),
	gen_server:cast(Name,{From, Fun, MsgRef}),
	ok.
		
isRunning(Id)->
	undefined==whereis(getServer(Id)).
	
getFreeServer()->
	getServer(hd([Id||Id<-lists:seq(1,3), isRunning(Id)])).
















