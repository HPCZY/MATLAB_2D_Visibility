function sightlight5()
close all; clc

% 界面
Fig = figure('Position',[200,100,1500,900],'menu','none',...
    'NumberTitle','off','Name','sightlight','Color',[0,0,0]);

width = 640;
height = 360;
axes(Fig,'Position',[0.1,0.1,0.8,0.8]);%'units','pixels','Position',[(800-width)/2,(600-height)/2,width,height]);
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
raynum = size(unique([segments(:,1:2);segments(:,3:4)],'rows'),1)*3;
HL = [];
HA = [];
sightnum = 6; % 视线数量
sightdis = 4; % 视线距离
bias = GetBias(sightnum,sightdis);

% 绘制
DrawScene()



%% 绘制背景

    function DrawScene(~,~)

        for n = 1:segnum
            H{n} = plot([segments(n,1),segments(n,3)],[segments(n,2),segments(n,4)],...
                '-','color',[0.5,0.5,0.5],'LineWidth',2);
        end
        x = zeros(1,raynum)+pos(1);
        y = zeros(1,raynum)+pos(2);
        for n = 1:sightnum
            HA{n} = fill(x,y,[1,1,1],'FaceAlpha',0.45,...
                'EdgeColor',[1,1,1],'EdgeAlpha',0);
            HA{n}.Faces = [1:raynum,1];
        end

        allpos = [pos;bias+pos];
        HL = plot(allpos(:,1),allpos(:,2),'r.','MarkerSize',10);

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
            allpos = [pos;bias+pos];
            for n = 1:sightnum+1
                postmp = allpos(n,:);
                angle = GetPoints(segments,postmp);
                for t = 1:length(angle)
                    vec = [cos(angle(t)),sin(angle(t))];
                    intersect = GetIntersection(postmp,vec,segments);
                    if ~isempty(intersect)
                        HA{n}.Vertices(t,:) = intersect;
                    end
                end
            end

            HL.XData = allpos(:,1);
            HL.YData = allpos(:,2);
            dt = toc;
            disp(round(1/dt))
        end
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
function angle = GetPoints(segments,pos)
points = unique([segments(:,1:2);segments(:,3:4)],'rows');
vec = points-pos;
angle = atan2(vec(:,2),vec(:,1));
angle = sort([angle;angle+1e-5;angle-1e-5]);

end
