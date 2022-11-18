
% gaurd function returns List of valid data types
gaurdList(LIST)
    -> LIST==[FLIST || {Shape,{Type,X,Y}}=FLIST<-LIST,
        ((Shape==triangle) or (Shape==rectangle) or (Shape==ellipse)),
        ((Type==dim) or Type==radius),
        ((X>0) and (Y>0))].

filterRectangle({shapes, LIST},false) -> throw();
filterRectangle({shapes, LIST},true)
    -> {shapes, [FLIST || {rectangle,{dim,_,_}}=FLIST <- LIST]}.

filterRectangle({shapes, LIST})
    -> filterRectangle({shapes, LIST},gaurdList(LIST)).

filterEllipse({shapes, LIST}) 
    -> {shapes, [FLIST || {ellipse,{radius,_,_}}=FLIST <- LIST]}.

filterTriangle({shapes, LIST}) 
    -> {shapes, [FLIST || {triangle,{dim,_,_}}=FLIST <- LIST]}.

filterSquare({shapes, LIST})
    -> {shapes, [FLIST || {rectangle,{dim,X,X}}=FLIST <- LIST]}.

filterCircle({shapes, LIST})
    -> {shapes, [FLIST || {ellipse,{radius,X,X}}=FLIST <- LIST]}.

% Filter functions of Type1:
shapesFilter(rectangle) -> fun filterRectangle/1;
shapesFilter(ellipse)   -> fun filterEllipse/1;
shapesFilter(triangle)  -> fun filterTriangle/1.

% Filter functions of type2:
shapesFilter2(rectangle) -> shapesFilter(rectangle);
shapesFilter2(ellipse)   -> shapesFilter(ellipse);
shapesFilter2(triangle)  -> shapesFilter(triangle);
shapesFilter2(square)    -> fun filterSquare/1;
shapesFilter2(circle)    -> fun filterCircle/1.