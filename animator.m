function animator(action) 
  
% rotation = 0; %rotate(1)
        L = 0.5;                                % pin length (from anchor to marker)
        A_ang = getappdata(gca,'A_ang');       % angle of anchor A in rigid body from centroid
        B_ang = getappdata(gca,'B_ang');       % angle of anchor B in rigid body from centroid
        C_ang = getappdata(gca,'C_ang');  %gcbf
        P1_ang = A_ang;                         % angle of marker from anchor A
        P2_ang = B_ang;                         % angle of marker from anchor B
        P3_ang = C_ang;
        Aa = 0.5;                               % dist from CG to A, 
        Bb = Aa;                                % dist from CG to B, 
        Cc = Aa;
        rb_thickness = 3;                       % how thick should rigid-body lines be?
        rb_color = 'k';                         % what colour should rigid-body be?
        pin_thickness = 2;                      % how thick should pin lines be?
%         pin_color = 'k';                        % what colour shuold pin lines be?
        set(gca,'NextPlot','replacechildren'); %replace children
         
switch(action)
    case 'start'
            
        set(gcbf,'WindowButtonMotionFcn','animator move')  % set motionfunction to the next CASE
        set(gcbf,'WindowButtonUpFcn','animator stop')      % make it so when butten released, last CASE
    
    case 'move'
        
        rotation = getappdata(gcbf,'scrollcount')*5;    % how much rigid body is rotated        
        tiime = getappdata(gca,'tiime')*0.01;
        currPt = get(gca,'CurrentPoint');
        CG(1) = currPt(1,1);
        CG(2) = currPt(1,2);
        
        A(1) = CG(1) + Aa*cosd(rotation+A_ang);
        A(2) = CG(2) + Aa*sind(rotation+A_ang);
        B(1) = CG(1) + Bb*cosd(rotation+B_ang); %centre of rotation, say
        B(2) = CG(2) + Bb*sind(rotation+B_ang);
        C(1) = CG(1) + Cc*cosd(rotation+C_ang);
        C(2) = CG(2) + Cc*sind(rotation+C_ang);
%         global P1 P2 P3
        mult = 0;
        P1(1) = A(1) + L*cosd(mult*tiime+rotation+P1_ang); %+flex1);
        P1(2) = A(2) + L*sind(mult*tiime+rotation+P1_ang); %+flex1);
        P2(1) = B(1) + L*cosd(mult*tiime+rotation+P2_ang); %+flex2);
        P2(2) = B(2) + L*sind(mult*tiime+rotation+P2_ang); %+flex2);
        P3(1) = C(1) + L*cosd(mult*tiime+rotation+P3_ang);
        P3(2) = C(2) + L*sind(mult*tiime+rotation+P3_ang);
        pts = [CG' A' B' C' P1' P2' P3'];
        
        setappdata(gca,'pts',pts(:,5:7));
        
        erasemode = 'none';

        plot(pts(1,1:4),pts(2,1:4),'.')
        plot(pts(1,5:7),pts(2,5:7),'.','color','k')
              
        axis([-2 2 -2 2])
        line([CG(1) CG(1)],[CG(2) CG(2)],'linewidth',rb_thickness,'color',rb_color,'EraseMode',erasemode) 
        line([0 CG(1)],[0 CG(2)],'LineStyle','--','linewidth',1)
        line([CG(1) A(1)],[CG(2) A(2)],'linewidth',rb_thickness,'color',rb_color,'EraseMode',erasemode)
        line([CG(1) B(1)],[CG(2) B(2)],'linewidth',rb_thickness,'color',rb_color,'EraseMode',erasemode)    
        line([CG(1) C(1)],[CG(2) C(2)],'linewidth',rb_thickness,'color',rb_color,'EraseMode',erasemode)    
%         line([A(1) B(1)],[A(2) B(2)],'linewidth',rb_thickness,'color',rb_color,'EraseMode',erasemode)
        line([A(1) P1(1)],[A(2) P1(2)],'linewidth',pin_thickness,'color','r','EraseMode',erasemode)
        line([B(1) P2(1)],[B(2) P2(2)],'linewidth',pin_thickness,'color','g','EraseMode',erasemode)
        line([C(1) P3(1)],[C(2) P3(2)],'linewidth',pin_thickness,'color','b','EraseMode',erasemode)
        viscircles(CG,Aa);
%         filledCircl(CG,Bb,100,'k');
       
    case 'stop'
       
        set(gcbf,'WindowButtonMotionFcn','')
        set(gcbf,'WindowButtonUpFcn','')

end 