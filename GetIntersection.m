% 算法
function intersect = GetIntersection(pos,vec,segments)

closestIntersect = 1e1000;
intersect = [];
for n = 1:size(segments,1)
    seg = segments(n,:);
    % 线段
    spx = seg(1);
    spy = seg(2);
    sdx = seg(3)-seg(1);
    sdy = seg(4)-seg(2);

    % 射线
    rpx = pos(1);
    rpy = pos(2);
    rdx = vec(1);
    rdy = vec(2);

    % 平行
    rmag = sqrt(rdx^2+rdy^2);
    smag = sqrt(sdx^2+sdy^2);
    if rdx/rmag==sdx/smag && rdy/rmag==sdy/smag
        continue
    end

    % 计算
    T2 = (rdx*(spy-rpy) + rdy*(rpx-spx))/(sdx*rdy - sdy*rdx);    
    if abs(rdx)>1e-4        
        T1 = (spx+sdx*T2-rpx)/rdx;
    else
        T1 = (spy+sdy*T2-rpy)/rdy;
    end

    if T1<0 || (T2<0 || T2>1)
        continue
    end

    % 交点
    if T1<closestIntersect
        intersect = [rpx+rdx*T1,rpy+rdy*T1];
        closestIntersect = T1;
    end
end

end