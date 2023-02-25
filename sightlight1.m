function sightlight1()
close all; clc

% 界面
Fig = figure('Position',[200,100,1500,900],'menu','none',...
    'NumberTitle','off','Name','sightlight');
axes(Fig,'Position',[0.1,0.1,0.8,0.8]);
width = 640;
height = 360;
xlim([0,width])
ylim([0,height])
axis("off")
axis('equal')
hold('on')

set(Fig,'WindowButtonMotionFcn',@ButtonMotion);
set(Fig,'WindowButtonDownFcn',@ButtonDown);

% 射线源
pos = [320,180];
vec = [0,0];
intersect = [0,0];
HL = [];
HR = [];
HI = [];

% 环境
H = [];
[segments,segnum,~,~] = GenerateSegments(width,height);

% 绘制
DrawScene()

%% 绘制背景

    function DrawScene(~,~)
        for n = 1:segnum
            H{n} = plot([segments(n,1),segments(n,3)],[segments(n,2),segments(n,4)],'k-','LineWidth',2);
        end
        HL = plot(pos(1),pos(2),'ro');
        HR = plot([pos(1),pos(1)],[pos(2),pos(2)],'r-');
        HI = plot(pos(1),pos(2),'r.','MarkerSize',15);
    end

%% 交互
    function ButtonDown(~,~)
        cp = get(gca,'currentpoint');
        x = cp(1,1);
        y = cp(1,2);
        if x>=0 && x<=width && y>=0 && y<=height
            pos = [cp(1,1),cp(1,2)];
            HL.XData = x;
            HL.YData = y;
            HR.XData = [x,x];
            HR.YData = [y,y];
            HI.XData = x;
            HI.YData = y;
        end
    end

    function ButtonMotion(~,~)
        % 点位
        cp = get(gca,'currentpoint');
        x = cp(1,1);
        y = cp(1,2);
        if x>=0 && x<=width && y>=0 && y<=height
            tic;
            vec = [x-pos(1),y-pos(2)];
            intersect = GetIntersection(pos,vec,segments);
            if ~isempty(intersect)
                HR.XData = [pos(1),intersect(1)];
                HR.YData = [pos(2),intersect(2)];
                HI.XData = intersect(1);
                HI.YData = intersect(2);
            end
            dt = toc;
            disp(round(1/dt))
        end
    end

end
