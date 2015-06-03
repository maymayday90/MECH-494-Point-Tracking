function plotrhcs(ctr,u1,v1,w1)

line([ctr(1),ctr(1)+u1(1)],[ctr(2),ctr(2)+u1(2)],[ctr(3),ctr(3)+u1(3)],'color','b');
line([ctr(1),ctr(1)+v1(1)],[ctr(2),ctr(2)+v1(2)],[ctr(3),ctr(3)+v1(3)],'color','g');
line([ctr(1),ctr(1)+w1(1)],[ctr(2),ctr(2)+w1(2)],[ctr(3),ctr(3)+w1(3)],'color','r');
xlabel('1');
ylabel('2');
zlabel('3');


end