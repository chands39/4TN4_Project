function landCoord = Landmarks(V,CONT,varv,landcont)
Elandmark =  V(1,:);
Dlandmark =  V(2,:);
Slandmark =  V(3,:);
Ilandmark =  V(4,:);
newposIlandmark =  V(5,:);
newposSlandmark =  V(6,:);
conts = CONT(2);
if (landcont == 4)
    
    if (conts == 1)      
        leftLandmark = [Elandmark(2)+varv(1,1),Elandmark(1)+varv(1,2)];
        rightLandmark = [Dlandmark(2)+varv(1,1),Dlandmark(1)+varv(1,2)];
        superiorLandmark = [newposIlandmark(2)+varv(1,1),newposIlandmark(1)+varv(1,2)];
        inferiorLandmark = [newposSlandmark(2)+varv(1,1),newposSlandmark(1)+varv(1,2)];
        landCoord = [leftLandmark, rightLandmark, superiorLandmark, inferiorLandmark];
    else
        leftLandmark = [Elandmark(2)+varv(1,1),Elandmark(1)+varv(1,2)];
        rightLandmark = [Dlandmark(2)+varv(1,1),Dlandmark(1)+varv(1,2)];
        superiorLandmark = [Slandmark(2)+varv(1,1),Slandmark(1)+varv(1,2)];
        inferiorLandmark = [Ilandmark(2)+varv(1,1),Ilandmark(1)+varv(1,2)];
        landCoord = [leftLandmark, rightLandmark, superiorLandmark, inferiorLandmark];    
    end
end
if (landcont == 5)
    
    Elandmark =  V(1,:);
    Dlandmark =  V(2,:);
    Slandmark =  V(3,:);
    Ilandmark =  V(4,:);
    newposIlandmark =  V(5,:);
    newposSlandmark =  V(6,:);
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
        leftLandmark = [Elandmark(2)+varv(1,1),Elandmark(1)+varv(1,2)];
        rightLandmark = [Dlandmark(2)+varv(1,1),Dlandmark(1)+varv(1,2)];
        inferiorLandmark = [newposIlandmark(2)+varv(1,1),newposIlandmark(1)+varv(1,2)];
        superiorLandmark = [newposSlandmark(2)+varv(1,1),newposSlandmark(1)+varv(1,2)];
        centralLandmark = [newposSlandmark(2)+varv(1,1),newposSlandmark(1)+varv(1,2)+de2];
        landCoord = [leftLandmark, rightLandmark, superiorLandmark, inferiorLandmark, centralLandmark];
    else
        leftLandmark = [Elandmark(2)+varv(1,1),Elandmark(1)+varv(1,2)];
        rightLandmark = [Dlandmark(2)+varv(1,1),Dlandmark(1)+varv(1,2)];
        inferiorLandmark = [Slandmark(2)+varv(1,1),Slandmark(1)+varv(1,2)];
        superiorLandmark = [Ilandmark(2)+varv(1,1),Ilandmark(1)+varv(1,2)];
        centralLandmark = [Slandmark(2)+varv(1,1),Slandmark(1)+varv(1,2)+de2];
        landCoord = [leftLandmark, rightLandmark, superiorLandmark, inferiorLandmark, centralLandmark];
    end
end
if (landcont == 2)
    
    Elandmark =  V(1,:);
    Dlandmark =  V(2,:);
    
    leftLandmark = [Elandmark(2)+varv(1,1),Elandmark(1)+varv(1,2)];
    rightLandmark = [Dlandmark(2)+varv(1,1),Dlandmark(1)+varv(1,2)];
    landCoord = [leftLandmark, rightLandmark];
    
end
end
