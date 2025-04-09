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
        
        plot(landmarkE(2)+varv(1,1),landmarkE(1)+varv(1,2),'w.', 'MarkerSize',5);
        plot(landmarkD(2)+varv(1,1),landmarkD(1)+varv(1,2),'w.', 'MarkerSize',5);
        plot(newposlandmarkI(2)+varv(1,1),newposlandmarkI(1)+varv(1,2),'w.', 'MarkerSize',5);
        plot(newposlandmarkS(2)+varv(1,1),newposlandmarkS(1)+varv(1,2),'w.', 'MarkerSize',5);
    else
        plot(landmarkE(2)+varv(1,1),landmarkE(1)+varv(1,2),'w.', 'MarkerSize',5);
        plot(landmarkD(2)+varv(1,1),landmarkD(1)+varv(1,2),'w.','MarkerSize',5);
        plot(landmarkS(2)+varv(1,1),landmarkS(1)+varv(1,2),'w.','MarkerSize',5);
        plot(landmarkI(2)+varv(1,1),landmarkI(1)+varv(1,2),'w.','MarkerSize',5);
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


if length(CONT) >= 3
    de2 = CONT(3);
else

    de2 = NaN; 

end


    if (conts == 1)
        plot(landmarkE(2)+varv(1,1),landmarkE(1)+varv(1,2),'w.','MarkerSize',5);
        plot(landmarkD(2)+varv(1,1),landmarkD(1)+varv(1,2),'w.','MarkerSize',5);
        plot(newposlandmarkI(2)+varv(1,1),newposlandmarkI(1)+varv(1,2),'w.','MarkerSize',5);
        plot(newposlandmarkS(2)+varv(1,1),newposlandmarkS(1)+varv(1,2),'w.','MarkerSize',5);
        plot(newposlandmarkS(2)+varv(1,1),newposlandmarkS(1)+varv(1,2)+de2,'r.','MarkerSize',5);
    else
        plot(landmarkE(2)+varv(1,1),landmarkE(1)+varv(1,2),'w.','MarkerSize',5);
        plot(landmarkD(2)+varv(1,1),landmarkD(1)+varv(1,2),'w.','MarkerSize',5);
        plot(landmarkS(2)+varv(1,1),landmarkS(1)+varv(1,2),'w.','MarkerSize',5);
        plot(landmarkI(2)+varv(1,1),landmarkI(1)+varv(1,2),'w.','MarkerSize',5);
        plot(landmarkS(2)+varv(1,1),landmarkS(1)+varv(1,2)+de2,'r.','MarkerSize',5);
    end
end
if (landcont == 2)
    
    landmarkE =  V(1,:);
    landmarkD =  V(2,:);
    
    plot(landmarkE(2)+varv(1,1),landmarkE(1)+varv(1,2),'w.','MarkerSize',5);
    plot(landmarkD(2)+varv(1,1),landmarkD(1)+varv(1,2),'w.','MarkerSize',5);
    
end
end
     