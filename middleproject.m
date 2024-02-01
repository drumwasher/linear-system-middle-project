clear all; clc;

car_data=stlread('copy_of_100_mine_camaro_template__1_.stl');
video_file=VideoWriter('test.avi');
video_file.FrameRate=30;
open(video_file)

%변수값
speed=1;
x_1=0;
r=pi/180*3;

%차량 10대 모델링값
car_data_rot0=car_data; car_data_rot1=car_data;
car_data_rot2=car_data; car_data_rot3=car_data;
car_data_rot4=car_data; car_data_rot5=car_data;
car_data_rot6=car_data; car_data_rot7=car_data;
car_data_rot8=car_data; car_data_rot9=car_data;

car_x=car_data.vertices(:,1)';
car_y=car_data.vertices(:,2)';
car_z=car_data.vertices(:,3)';

car = [car_x;car_y;car_z;ones(1,length(car_x))];

%도로의 선 좌표값
load_x1=[-300 500]; load_y1=[0 0];
load_x2=[500 500] ; load_y2=[-500 0];

%자동차의 회전
car_yaw=90/180*pi;
R_z0=[cos(car_yaw) -sin(car_yaw) 0 0;
     sin(car_yaw) cos(car_yaw) 0 0;
     0 0 1 0;
     0 0 0 1];
R_z1=[cos(car_yaw*2) -sin(car_yaw*2) 0 0;
     sin(car_yaw*2) cos(car_yaw*2) 0 0;
     0 0 1 0;
     0 0 0 1];
R_z2=[cos(car_yaw*3) -sin(car_yaw*3) 0 0;
     sin(car_yaw*3) cos(car_yaw*3) 0 0;
     0 0 1 0;
     0 0 0 1];

R=[1 0 0 0;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1];

%차량 최초위치
R0=R; R0(1,4)=50    ;R0(2,4)=17;  
R1=R; R1(1,4)=-50   ;R1(2,4)=47;
R2=R; R2(1,4)=600   ;R2(2,4)=67+5;
R3=R; R3(1,4)=1000  ;R3(2,4)=97+5;
R4=R; R4(1,4)=517   ;R4(2,4)=150;
R5=R; R5(1,4)=547   ;R5(2,4)=600;
R6=R; R6(1,4)=1400  ;R6(2,4)=67+5;
R7=R; R7(1,4)=1600  ;R7(2,4)=97+5;
R8=R; R8(1,4)=597+5 ;R8(2,4)=-70+40;
R9=R; R9(1,4)=577   ;R9(2,4)=-570;

figure(1);
for x=0:speed:1300
    clf;
    % 차량의 이동 및 멈춤 조절
    if x<=430 || x>=750 
        R0(1,4)=R0(1,4)+speed;
    end
    
    if x<400 || x>=750
        R1(1,4)=R1(1,4)+speed*1.3;
    end
    
    R2(1,4)=R2(1,4)-speed;
    R3(1,4)=R3(1,4)-speed*1.5;

    if x<=470
        R5(2,4)=R5(2,4)-speed;
    elseif x>=550
        R5(1,4)=R5(1,4)+speed;
    else
        r=r+pi/180*speed;
        Rz_r=[cos(r) -sin(r) 0 0;
              sin(r)  cos(r) 0 0;
              0 0 1 0;
              0 0 0 1];
        R5(1,4)=R5(1,4)+speed;
        R5(2,4)=R5(2,4)-speed;
    end

    if x<=480 || x>=750
        R6(1,4)=R6(1,4)-speed*1.5;
    end
    
    R7(1,4)=R7(1,4)-speed*1.3;

    
    R9(2,4)=R9(2,4)+speed;
    

    if x>=550
        R4(2,4)=R4(2,4)-speed;
        R8(2,4)=R8(2,4)+speed;
        R9(2,4)=R9(2,4)+speed*1.5;
    end

    %계산된 평행이동과 회전의 결과
    car_rot0=R0*R_z0*car;
    car_rot1=R1*R_z0*car;
    car_rot2=R2*R_z2*car;
    car_rot3=R3*R_z2*car;
    car_rot4=R4*car;

    if x<=470
        car_rot5=R5*car;
    elseif x>=550
        car_rot5=R5*R_z0*car;
    else
        car_rot5=R5*Rz_r*car;
    end

    car_rot6=R6*R_z2*car;
    car_rot7=R7*R_z2*car;
    car_rot8=R8*R_z1*car;
    car_rot9=R9*R_z1*car;
    
    %patch를 그리기 위해 계산한 결과 저장
    car_data_rot0.vertices = car_rot0([1:3],:)';
    car_data_rot1.vertices = car_rot1([1:3],:)';
    car_data_rot2.vertices = car_rot2([1:3],:)';
    car_data_rot3.vertices = car_rot3([1:3],:)';
    car_data_rot4.vertices = car_rot4([1:3],:)';
    car_data_rot5.vertices = car_rot5([1:3],:)';
    car_data_rot6.vertices = car_rot6([1:3],:)';
    car_data_rot7.vertices = car_rot7([1:3],:)';
    car_data_rot8.vertices = car_rot8([1:3],:)';
    car_data_rot9.vertices = car_rot9([1:3],:)';
    
    %================전방=========================
    subplot(2,1,1)
    %grid on; box on;
    axis equal;
    
    set(gca,'xtick',[],'ytick',[],'ztick',[])
    title('차안전방시점')
    rectangle('Position',[-300,-500,1720,1120],'FaceColor',[.7 .7 .7])

     %도로 선 (아래)
    line(load_x1,load_y1,'Color','k','LineStyle','-','LineWidth',2)
    line(load_x1,load_y1+30,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x1,load_y1+60,'Color','y','LineStyle','-','LineWidth',2)
    line(load_x1,load_y1+90,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x1,load_y1+120,'Color','k','LineStyle','-','LineWidth',2)
    
    %도로 선 (위)
    line(load_x1+920,load_y1,'Color','k','LineStyle','-','LineWidth',2)
    line(load_x1+920,load_y1+30,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x1+920,load_y1+60,'Color','y','LineStyle','-','LineWidth',2)
    line(load_x1+920,load_y1+90,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x1+920,load_y1+120,'Color','k','LineStyle','-','LineWidth',2)

    %도로 선 (오른쪽)
    line(load_x2,load_y2,'Color','k','LineStyle','-','LineWidth',2)
    line(load_x2+30,load_y2,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x2+60,load_y2,'Color','y','LineStyle','-','LineWidth',2)
    line(load_x2+90,load_y2,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x2+120,load_y2,'Color','k','LineStyle','-','LineWidth',2)
    
    %도로 선 (왼쪽)
    line(load_x2,load_y2+620,'Color','k','LineStyle','-','LineWidth',2)
    line(load_x2+30,load_y2+620,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x2+60,load_y2+620,'Color','y','LineStyle','-','LineWidth',2)
    line(load_x2+90,load_y2+620,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x2+120,load_y2+620,'Color','k','LineStyle','-','LineWidth',2)

    patch(car_data_rot0,'FaceColor','r','EdgeColor','r');
    patch(car_data_rot1,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot2,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot3,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot4,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot5,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot6,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot7,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot8,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot9,'FaceColor','b','EdgeColor','b');

    xlabel('x');ylabel('y');zlabel('z');
    view(-90,10);
    

    if x<=430 || x>=750 
        xlim([x-x_1 300+x-x_1]);ylim([-150 200]);zlim([0 50]);
        xlim([70+x-x_1 300+x-x_1]);ylim([-100 200]);zlim([0 50]);
    else
        x_1=x_1+speed;
        xlim([70+430 300+430]);ylim([-100 200]);zlim([0 50]);
    end
    
    %================허공=========================
    subplot(2,2,3)
    %grid on; box on;
    axis equal;
    
    set(gca,'xtick',[],'ytick',[],'ztick',[])
    title('허공시점')
    rectangle('Position',[-300,-500,1720,1120],'FaceColor',[.7 .7 .7])

    %도로 선 (아래)
    line(load_x1,load_y1,'Color','k','LineStyle','-','LineWidth',2)
    line(load_x1,load_y1+30,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x1,load_y1+60,'Color','y','LineStyle','-','LineWidth',2)
    line(load_x1,load_y1+90,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x1,load_y1+120,'Color','k','LineStyle','-','LineWidth',2)
    
    %도로 선 (위)
    line(load_x1+920,load_y1,'Color','k','LineStyle','-','LineWidth',2)
    line(load_x1+920,load_y1+30,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x1+920,load_y1+60,'Color','y','LineStyle','-','LineWidth',2)
    line(load_x1+920,load_y1+90,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x1+920,load_y1+120,'Color','k','LineStyle','-','LineWidth',2)

    %도로 선 (오른쪽)
    line(load_x2,load_y2,'Color','k','LineStyle','-','LineWidth',2)
    line(load_x2+30,load_y2,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x2+60,load_y2,'Color','y','LineStyle','-','LineWidth',2)
    line(load_x2+90,load_y2,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x2+120,load_y2,'Color','k','LineStyle','-','LineWidth',2)
    
    %도로 선 (왼쪽)
    line(load_x2,load_y2+620,'Color','k','LineStyle','-','LineWidth',2)
    line(load_x2+30,load_y2+620,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x2+60,load_y2+620,'Color','y','LineStyle','-','LineWidth',2)
    line(load_x2+90,load_y2+620,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x2+120,load_y2+620,'Color','k','LineStyle','-','LineWidth',2)

    patch(car_data_rot0,'FaceColor','r','EdgeColor','r');
    patch(car_data_rot1,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot2,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot3,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot4,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot5,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot6,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot7,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot8,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot9,'FaceColor','b','EdgeColor','b');
    alpha(0.3)

    xlabel('x');ylabel('y');zlabel('z');
    view(0,90);
    xlim([0 1000+100]);ylim([-400 500]);zlim([0 50]);
    
    %================FSD=========================
    subplot(2,2,4)
    %grid on; box on;
    axis equal;
    
    set(gca,'xtick',[],'ytick',[],'ztick',[])
    title('FSD화면')
    rectangle('Position',[-300,-500,1720,1120],'FaceColor',[.7 .7 .7])

    %도로 선 (아래)
    line(load_x1,load_y1,'Color','k','LineStyle','-','LineWidth',2)
    line(load_x1,load_y1+30,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x1,load_y1+60,'Color','y','LineStyle','-','LineWidth',2)
    line(load_x1,load_y1+90,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x1,load_y1+120,'Color','k','LineStyle','-','LineWidth',2)
    
    %도로 선 (위)
    line(load_x1+920,load_y1,'Color','k','LineStyle','-','LineWidth',2)
    line(load_x1+920,load_y1+30,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x1+920,load_y1+60,'Color','y','LineStyle','-','LineWidth',2)
    line(load_x1+920,load_y1+90,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x1+920,load_y1+120,'Color','k','LineStyle','-','LineWidth',2)

    %도로 선 (오른쪽)
    line(load_x2,load_y2,'Color','k','LineStyle','-','LineWidth',2)
    line(load_x2+30,load_y2,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x2+60,load_y2,'Color','y','LineStyle','-','LineWidth',2)
    line(load_x2+90,load_y2,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x2+120,load_y2,'Color','k','LineStyle','-','LineWidth',2)
    
    %도로 선 (왼쪽)
    line(load_x2,load_y2+620,'Color','k','LineStyle','-','LineWidth',2)
    line(load_x2+30,load_y2+620,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x2+60,load_y2+620,'Color','y','LineStyle','-','LineWidth',2)
    line(load_x2+90,load_y2+620,'Color','w','LineStyle','--','LineWidth',2)
    line(load_x2+120,load_y2+620,'Color','k','LineStyle','-','LineWidth',2)

    patch(car_data_rot0,'FaceColor','r','EdgeColor','r');
    patch(car_data_rot1,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot2,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot3,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot4,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot5,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot6,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot7,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot8,'FaceColor','b','EdgeColor','b');
    patch(car_data_rot9,'FaceColor','b','EdgeColor','b');

    xlabel('x');ylabel('y');zlabel('z');
    view(-80,30)
    if x<=430 || x>=750 
        xlim([x-x_1 300+x-x_1]);ylim([-150 200]);zlim([0 50]);
    else
        xlim([430 300+430]);ylim([-150 200]);zlim([0 50]);
    end
    
    frame=getframe(gcf);
    writeVideo(video_file,frame);
    refresh
    drawnow limitrate
end

close(video_file)