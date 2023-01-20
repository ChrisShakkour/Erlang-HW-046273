-module(sup).
-behaviour(supervisor).

-export([start/0 , init/1]).

start() ->
    unlink(element(2,supervisor:start_link({local,sup}, ?MODULE, []))).

init(_Args) ->
    SupFlags = #{strategy => simple_one_for_one}, 
    ChildSpecs = [#{id => server,
                    start => {server, start_link, []},
                    shutdown => brutal_kill}],
    {ok, {SupFlags, ChildSpecs}}.
	