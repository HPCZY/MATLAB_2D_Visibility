function [segments,segnum,Obj,objnum] = GenerateSegments(width,height)

    % 画你的图形
    Obj{1} = SetSegment([0,width,width,0,0],[0,0,height,height,0]);
    Obj{2} = SetSegment([100,120,60,100],[200,250,300,200]);
	Obj{3} = SetSegment([200,220,300,350],[260,210,230,320]);
	Obj{4} = SetSegment([200,200,300,300,220,220,430,430,350,350,450],...
                        [50,120,120,100,100,50,50,100,100,120,120]);
	Obj{5} = SetSegment([450,560,540,430,450],[220,200,270,290,220]);	
	Obj{6} = SetSegment([70,140,90,50],[50,80,150,120]);
    Obj{12} = SetSegment([550,550],[160,180]);
    Obj{7} = SetSegment([550,550],[150,130]);
    Obj{8} = SetSegment([550,550],[100,120]);
    Obj{9} = SetSegment([550,535],[90,75]);
    Obj{10} = SetSegment([520,505],[60,45]);
    Obj{11} = SetSegment([490,475],[30,15]);
    objnum = length(Obj);

    segments = [];
    for n = 1:objnum
        segments = [segments;Obj{n}.line];
    end
    segnum = size(segments,1);
end

function param = SetSegment(x,y)

    param.x = x;
    param.y = y;
    vertexNum = length(x);
    param.line = zeros(vertexNum,4);
    for n = 1:vertexNum-1
        if n<vertexNum
            param.line(n,:) = [x(n),y(n),x(n+1),y(n+1)];
        else
            param.line(n,:) = [x(n),y(n),x(1),y(1)];
        end
    end
    
end