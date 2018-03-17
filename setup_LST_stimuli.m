function  [drawData] = setup_LST_stimuli(rect,linewidth)
% Stimuli setup
xCentre = rect(3) / 2; %xCentre coordinate
yCentre = rect(4) / 2; %yCentre coordinate
drawData.sLength  = (rect(4)/16); %length of side of square

% Stimuli positions and coordinates
drawData.stimPos(1,[1 5 9 13]) = xCentre-(3*drawData.sLength)+(1.5*linewidth); %x coordinates
drawData.stimPos(1,[2 6 10 14]) = xCentre-(drawData.sLength)+(0.5*linewidth);
drawData.stimPos(1,[3 7 11 15]) = xCentre+(drawData.sLength)-(0.5*linewidth);
drawData.stimPos(1,[4 8 12 16]) = xCentre+(3*drawData.sLength)-(1.5*linewidth);
drawData.stimPos(2,1:4) = yCentre-(3*drawData.sLength)+(1.5*linewidth);        %y coordinates
drawData.stimPos(2,5:8) = yCentre-(drawData.sLength)+(0.5*linewidth);
drawData.stimPos(2,9:12) = yCentre+(drawData.sLength)-(0.5*linewidth);
drawData.stimPos(2,13:16) = yCentre+(3*drawData.sLength)-(1.5*linewidth);
drawData.Rects(1,1:16) = drawData.stimPos(1,1:16)-drawData.sLength;                     %Rectangle
drawData.Rects(2,1:16) = drawData.stimPos(2,1:16)-drawData.sLength;                     %coordinates
drawData.Rects(3,1:16) = drawData.stimPos(1,1:16)+drawData.sLength;
drawData.Rects(4,1:16) = drawData.stimPos(2,1:16)+drawData.sLength;
drawData.shapeRect(1,1:16) = drawData.Rects(1,1:16)+(0.3*drawData.sLength);             %Shapes:
drawData.shapeRect(2,1:16) = drawData.Rects(2,1:16)+(0.3*drawData.sLength);             %rectanges and
drawData.shapeRect(3,1:16) = drawData.Rects(3,1:16)-(0.3*drawData.sLength);             %circles
drawData.shapeRect(4,1:16) = drawData.Rects(4,1:16)-(0.3*drawData.sLength);
drawData.shapeTri(1,1:2:32)= drawData.stimPos(1,1:16);                        %triangles
drawData.shapeTri(1,2:2:32)= drawData.stimPos(2,1:16)-(0.75*drawData.sLength);
drawData.shapeTri(2,1:2:32)= drawData.stimPos(1,1:16)+(0.75*drawData.sLength);
drawData.shapeTri(2,2:2:32)= drawData.stimPos(2,1:16)+(0.75*drawData.sLength);
drawData.shapeTri(3,1:2:32)= drawData.stimPos(1,1:16)-(0.75*drawData.sLength);
drawData.shapeTri(3,2:2:32)= drawData.stimPos(2,1:16)+(0.75*drawData.sLength);
drawData.shapeCrossA(1,1:16) = drawData.Rects(1,1:16)+(0.75*drawData.sLength);          %crosses
drawData.shapeCrossA(2,1:16) = drawData.Rects(2,1:16)+(0.3*drawData.sLength);
drawData.shapeCrossA(3,1:16) = drawData.Rects(3,1:16)-(0.75*drawData.sLength);
drawData.shapeCrossA(4,1:16) = drawData.Rects(4,1:16)-(0.3*drawData.sLength);
drawData.shapeCrossB(1,1:16) = drawData.Rects(1,1:16)+(0.3*drawData.sLength);
drawData.shapeCrossB(2,1:16) = drawData.Rects(2,1:16)+(0.75*drawData.sLength);
drawData.shapeCrossB(3,1:16) = drawData.Rects(3,1:16)-(0.3*drawData.sLength);
drawData.shapeCrossB(4,1:16) = drawData.Rects(4,1:16)-(0.75*drawData.sLength);

end

