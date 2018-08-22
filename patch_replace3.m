function D=patch_replace3(I,rw,cl,ro,co)
        patch_q=patch_creation3(I,rw,cl);
        D=I;
        D(ro,co,:)=I(rw,cl,:);
        D(ro-1,co-1,:)=patch_q(1,:) ; % Upper left.  rw = row, cl = column.
        D(ro-1,co,:)=patch_q(2,:) ; % left.  rw = row, cl = column.
        D(ro-1,co+1,:)=patch_q(3,:) ; % lower left.  rw = row, cl = column.
        D(ro,co-1,:)=patch_q(4,:) ; % upper middle.  rw = row, cl = column.
        D(ro,co+1,:)=patch_q(5,:) ; % lower middle. rw = row, cl = column.
        D(ro+1,co+1,:)=patch_q(6,:) ; % Lower right .  rw = row, cl = column.
        D(ro+1,co,:)=patch_q(7,:) ; % right.  rw = row, cl = column.
        D(ro+1,co-1,:)=patch_q(8,:) ; % upper right.  rw = row, cl = column.
end