function sightlight6()
close all; clc

% 界面
Fig = figure('Position',[200,100,1500,900],'menu','none',...
    'NumberTitle','off','Name','sightlight');

width = 640;
height = 360;
axes(Fig,'Position',[0.1,0.1,0.8,0.8]);
xlim([0,width])
ylim([0,height])
axis("off")
axis('equal')
hold('on')

set(Fig,'WindowButtonMotionFcn',@ButtonMotion);
set(Fig,'WindowButtonDownFcn',@ButtonDown);

% 环境
H = [];
[segments,segnum,~,~] = GenerateSegments(width,height);

% 射线源
pos = [320,180];
ray = [1,1];
range = pi/6;
HL = [];
HA = [];
HR = [];
HI = [];


% 绘制
DrawScene()
updata()

%% 绘制背景

    function DrawScene(~,~)

        for n = 1:segnum
            H{n} = plot([segments(n,1),segments(n,3)],[segments(n,2),segments(n,4)],...
                '-','color',[0.5,0.5,0.5],'LineWidth',2);
        end

        HR = plot([pos(1),pos(1)],[pos(2),pos(2)],'r-');
        HI = plot(pos(1),pos(2),'r.','MarkerSize',15);
        HL = plot(pos(1),pos(2),'r.','MarkerSize',20);

    end


%% 交互
    function ButtonDown(~,~)
        cp = get(gca,'currentpoint');
        x = cp(1,1);
        y = cp(1,2);
        if x>=0 && x<=width && y>=0 && y<=height
            pos = [cp(1,1),cp(1,2)];
            updata()
        end
    end

    function ButtonMotion(~,~)
        % 点位
        cp = get(gca,'currentpoint');
        x = cp(1,1);
        y = cp(1,2);
        if x>=0 && x<=width && y>=0 && y<=height
            ray = [x-pos(1),y-pos(2)];
            updata()
        end
    end

    function updata(~,~)
        tic;
        HL.XData = pos(1);
        HL.YData = pos(2);

        angle = GetPoints(segments,pos,ray,range);
        tmp = [];
        for t = 1:length(angle)
            V = [cos(angle(t)),sin(angle(t))];
            intersect = GetIntersection(pos,V,segments);
            if ~isempty(intersect)
                tmp = [tmp;intersect];
            end
        end

        % 更新绘图
        HI.XData = tmp(:,1);
        HI.YData = tmp(:,2);

        x = [zeros(1,size(tmp,1))+pos(1);tmp(:,1)'];
        y = [zeros(1,size(tmp,1))+pos(2);tmp(:,2)'];
        delete(HR)
        HR = plot(x,y,'r-');
        HA.Vertices = tmp;
        HA.Faces = [1:length(tmp),1];

        HL.XData = pos(:,1);
        HL.YData = pos(:,2);
        dt = toc;
        disp(round(1/dt))
    end


end




%% 获取视线偏移
function bias = GetBias(sightnum,len)
bias = zeros(sightnum,2);
for n = 1:sightnum
    bias(n,:) = len*[cos(2*pi*n/sightnum),sin(2*pi*n/sightnum)];
end
end

%% 获取关键点
function angle = GetPoints(segments,pos,ray,range)
% 范围线
theta = atan2(ray(2),ray(1));

% 顶点线
points = unique([segments(:,1:2);segments(:,3:4)],'rows');
vec = points-pos;
angle = atan2(vec(:,2),vec(:,1));
angle = sort([angle;angle+1e-5;angle-1e-5]);

% 剔除
angle = angle-theta;
angle(angle>pi) = angle(angle>pi)-2*pi;
angle(angle<-pi) = angle(angle<-pi)+2*pi;
angle(angle>range) = [];
angle(angle<-range) = [];
angle = [-range;angle;range];
angle = angle+theta;
angle(angle>pi) = angle(angle>pi)-2*pi;
angle(angle<-pi) = angle(angle<-pi)+2*pi;

end
