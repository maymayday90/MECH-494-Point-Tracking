% For inversion of poses for multiplication

function inv_pose = invertpose(T)


inv_pose(2:4,1)=-transpose(T(2:4,2:4))*T(2:4,1);
inv_pose(2:4,2:4)=transpose(T(2:4,2:4));
inv_pose(1,1:4)=[1 0 0 0];


end

