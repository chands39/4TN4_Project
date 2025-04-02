function showsLandmarks(V,CONT,varv,landcont)

landmarkE =  V(1,:);
landmarkD =  V(2,:);
landmarkS =  V(3,:);
landmarkI =  V(4,:);
newposlandmarkI =  V(5,:);
newposlandmarkS =  V(6,:);
conts = CONT(2);

disp('CONT contents:');
disp(CONT);
disp(['Size of CONT: ', num2str(length(CONT))]);

if (landcont == 4)
    
    if (conts == 1)
        
        plot(landmarkE(2)+varv(1,1),landmarkE(1)+varv(1,2),'w.');
        plot(landmarkD(2)+varv(1,1),landmarkD(1)+varv(1,2),'w.');
        plot(newposlandmarkI(2)+varv(1,1),newposlandmarkI(1)+varv(1,2),'w.');
        plot(newposlandmarkS(2)+varv(1,1),newposlandmarkS(1)+varv(1,2),'w.');
    else
        plot(landmarkE(2)+varv(1,1),landmarkE(1)+varv(1,2),'w.');
        plot(landmarkD(2)+varv(1,1),landmarkD(1)+varv(1,2),'w.');
        plot(landmarkS(2)+varv(1,1),landmarkS(1)+varv(1,2),'w.');
        plot(landmarkI(2)+varv(1,1),landmarkI(1)+varv(1,2),'w.');
    end
end
if (landcont == 5)
    
    landmarkE =  V(1,:);
    landmarkD =  V(2,:);
    landmarkS =  V(3,:);
    landmarkI =  V(4,:);
    newposlandmarkI =  V(5,:);
    newposlandmarkS =  V(6,:);
    conts = CONT(2);
    % Assuming CONT is populated somewhere before this point

if length(CONT) >= 3
    de2 = CONT(3);
else
    % Handle missing third element, e.g., set to NaN or some default
    de2 = NaN; 
    % Or handle this case in another way, depending on the logic
end


    if (conts == 1)
        plot(landmarkE(2)+varv(1,1),landmarkE(1)+varv(1,2),'w.');
        plot(landmarkD(2)+varv(1,1),landmarkD(1)+varv(1,2),'w.');
        plot(newposlandmarkI(2)+varv(1,1),newposlandmarkI(1)+varv(1,2),'w.');
        plot(newposlandmarkS(2)+varv(1,1),newposlandmarkS(1)+varv(1,2),'w.');
        plot(newposlandmarkS(2)+varv(1,1),newposlandmarkS(1)+varv(1,2)+de2,'r.');
    else
        plot(landmarkE(2)+varv(1,1),landmarkE(1)+varv(1,2),'w.');
        plot(landmarkD(2)+varv(1,1),landmarkD(1)+varv(1,2),'w.');
        plot(landmarkS(2)+varv(1,1),landmarkS(1)+varv(1,2),'w.');
        plot(landmarkI(2)+varv(1,1),landmarkI(1)+varv(1,2),'w.');
        plot(landmarkS(2)+varv(1,1),landmarkS(1)+varv(1,2)+de2,'r.');
    end
end
if (landcont == 2)
    
    landmarkE =  V(1,:);
    landmarkD =  V(2,:);
    
    plot(landmarkE(2)+varv(1,1),landmarkE(1)+varv(1,2),'w.');
    plot(landmarkD(2)+varv(1,1),landmarkD(1)+varv(1,2),'w.');
    
end
end
     
