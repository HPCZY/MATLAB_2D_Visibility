function sightlight7()
close all; clc

% 界面
Fig = figure('Position',[200,100,1500,900],'menu','none',...
    'NumberTitle','off','Name','sightlight','Color',[0,0,0]);

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
range = pi/5;
raynum = size(unique([segments(:,1:2);segments(:,3:4)],'rows'),1)*3;
HL = [];
HA = [];
sightnum = 6;
bias = GetBias(sightnum,3);

% 绘制
DrawScene()
updata()

%% 绘制背景

    function DrawScene(~,~)

        for n = 1:segnum
            H{n} = plot([segments(n,1),segments(n,3)],[segments(n,2),segments(n,4)],...
                '-','color',[0.5,0.5,0.5],'LineWidth',2);
        end
        x = zeros(1,raynum)+pos(1);
        y = zeros(1,raynum)+pos(2);
        for n = 1:sightnum+1
            HA{n} = fill(x,y,[1,1,1],'FaceAlpha',0.45,...
                'EdgeColor',[1,1,1],'EdgeAlpha',0);
            HA{n}.Faces = [1:raynum,1];
        end

        allpos = [pos;bias+pos];
        HL = plot(allpos(:,1),allpos(:,2),'r.','MarkerSize',10);

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
        allpos = [pos;bias+pos];
        for n = 1:sightnum+1
            postmp = allpos(n,:);
            angle = GetPoints(segments,postmp,ray,range);
            tmp = pos;
            for t = 1:length(angle)
                V = [cos(angle(t)),sin(angle(t))];
                intersect = GetIntersection(postmp,V,segments);
                if ~isempty(intersect)
                    tmp = [tmp;intersect];
                end
            end          
            
            delete(HA{n})
            HA{n} = fill(tmp(:,1),tmp(:,2),[1,1,01],'FaceAlpha',0.35,...
                'EdgeColor',[1,1,1],'EdgeAlpha',0);
            HA{n}.Faces = [1:length(tmp),1];
 
        end

        HL.XData = allpos(:,1);
        HL.YData = allpos(:,2);
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

% 剔除
angle = angle-theta;
angle(angle>pi) = angle(angle>pi)-2*pi;
angle(angle<-pi) = angle(angle<-pi)+2*pi;
angle(angle>range) = [];
angle(angle<-range) = [];
angle = [-range;angle;range];
angle = sort([angle;angle+1e-5;angle-1e-5]);
angle = angle+theta;
angle(angle>pi) = angle(angle>pi)-2*pi;
angle(angle<-pi) = angle(angle<-pi)+2*pi;


end
