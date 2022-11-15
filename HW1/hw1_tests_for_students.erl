-module(hw1_tests_for_students).
-export ([run_test/0]).


%---valid shapes

validRectangle1() -> {rectangle,{dim,1,2}}.		% size 2
validRectangle3() -> {rectangle,{dim,5,5}}.		% size 25
validRectangle4() -> {rectangle,{dim,1,1}}.		% size 1

validTriangle2() -> {triangle,{dim,3,2}}.		% size 3
validTriangle3() -> {triangle,{dim,4,4}}.		% size 8

validEllipse1() -> {ellipse,{radius,1,2}}.       	
validEllipse2() -> {ellipse,{radius,3,2}}.			

%---valid structs
validShapes1() -> {shapes,[validEllipse1(), validEllipse1(), validRectangle1(), validTriangle2(), validRectangle3() ]}.
validShapes4() -> {shapes,[validEllipse2(),validRectangle1(), validTriangle2() , validTriangle3(), validRectangle3(), validRectangle4()]}.


run_test() ->
	io:format("expecting ~p and got ~p ~n",[57.84955592153876,shapes:shapesArea(validShapes4())]),
	
	Fun1 = shapes:shapesFilter(rectangle),
	Fun2 = shapes:shapesFilter(triangle),
	Fun3 = shapes:shapesFilter(ellipse),
	Fun4 = shapes:shapesFilter2(rectangle),
	Fun5 = shapes:shapesFilter2(triangle),
	Fun6 = shapes:shapesFilter2(ellipse),
	Fun7 = shapes:shapesFilter2(square),
	Fun8 = shapes:shapesFilter2(circle),
	io:format("expecting rectangles only and got ~p ~n",[Fun1(validShapes1())]),
	io:format("expecting triangles only and got ~p ~n",[Fun2(validShapes1())]),
	io:format("expecting ellipse only and got ~p ~n",[Fun3(validShapes1())]),
	io:format("expecting rectangles only and got ~p ~n",[Fun4(validShapes1())]),
	io:format("expecting triangles only and got ~p ~n",[Fun5(validShapes1())]),
	io:format("expecting ellipse only and got ~p ~n",[Fun6(validShapes1())]),
	io:format("expecting squere only and got ~p ~n",[Fun7(validShapes1())]),
	io:format("expecting circle only and got ~p ~n",[Fun8(validShapes1())]),
	io:format("expecting ~p and got ~p ~n",[3.0,shapes:trianglesArea(validShapes1())]),
	io:format("expecting ~p and got ~p ~n",[11.0,shapes:trianglesArea(validShapes4())]),
	io:format("expecting ~p and got ~p ~n",[25.0,shapes:squaresArea(validShapes1())]),
	io:format("expecting ~p and got ~p ~n",[26.0,shapes:squaresArea(validShapes4())]),
	
	io:format("expecting ~p and got ~p ~n",[true,game:canWin(2)]),
	io:format("expecting ~p and got ~p ~n",[false,game:canWin(3)]).



	