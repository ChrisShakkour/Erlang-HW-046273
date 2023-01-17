-module(sup).
-behaviour(supervisor).

-export([start/0]).
-export([init/1]).


%% ~~~~~ exported functions ~~~~~

start() ->
    unlink(element(2,supervisor:start_link({local,sup}, ?MODULE, []))).
	%supervisor:start_link({local,sup}, ?MODULE, []).
	
%% ~~~~~ behaviour functions ~~~~~

init(_Args) ->
    SupFlags = #{strategy => simple_one_for_one}, %Intensety = 1, Period = 5, by default
    ChildSpecs = [#{id => server,
                    start => {server, start_link, []},
                    shutdown => brutal_kill}],
    {ok, {SupFlags, ChildSpecs}}.
	