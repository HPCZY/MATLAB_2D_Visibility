function sightlight3()
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
% set(Fig,'WindowButtonDownFcn',@ButtonDown);

% 环境
H = [];
[segments,segnum,~,~] = GenerateSegments(width,height);

% 射线源
pos = [320,180];
raynum = 3*size(unique([segments(:,1:2);segments(:,3:4)],'rows'),1);
intersect = [0,0];
HL = [];
HR = [];
HI = [];
HA = [];

% 绘制
DrawScene()

%% 绘制背景

    function DrawScene(~,~)

        for n = 1:segnum
            H{n} = plot([segments(n,1),segments(n,3)],[segments(n,2),segments(n,4)],'k-','LineWidth',2);
        end
        HL = plot(pos(1),pos(2),'ro');

        for n = 1:raynum
            HR{n} = plot([pos(1),pos(1)],[pos(2),pos(2)],'r-');
            HI{n} = plot(pos(1),pos(2),'r.','MarkerSize',15);
        end
    end


%% 交互

    function ButtonMotion(~,~)
        % 点位
        cp = get(gca,'currentpoint');
        x = cp(1,1);
        y = cp(1,2);

        if x>=0 && x<=width && y>=0 && y<=height
            tic;
            pos = [cp(1,1),cp(1,2)];
            HL.XData = x;
            HL.YData = y;
            angle = GetPoints(segments,pos);
            for t = 1:length(angle)
                vec = [cos(angle(t)),sin(angle(t))];
                intersect = GetIntersection(pos,vec,segments);
                if ~isempty(intersect)
                    HR{t}.XData = [pos(1),intersect(1)];
                    HR{t}.YData = [pos(2),intersect(2)];
                    HI{t}.XData = intersect(1);
                    HI{t}.YData = intersect(2);
                end
            end

            dt = toc;
            disp(round(1/dt))
        end
    end
end


%% 获取关键点
function angle = GetPoints(segments,pos)
points = unique([segments(:,1:2);segments(:,3:4)],'rows');
vec = points-pos;
angle = atan2(vec(:,2),vec(:,1));
angle = [angle;angle+1e-5;angle-1e-5]; % 别问，问就是骚操作
end
