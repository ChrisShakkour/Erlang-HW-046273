-module(sup).
-export([restarter/0]).

restarter() ->
	process_flag(trap_exit, true),
	Pid = spawn_link(matrix_server, server, []),
	register(matrix_server, Pid),
	receive
		{'EXIT', Pid, normal} -> ok; % no crash
		{'EXIT', Pid, _} -> flush(), restarter() % restart
	end.
	
flush()->
	receive
		_ -> flush()
		after 0 -> ok
	end.