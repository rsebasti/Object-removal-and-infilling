function n=patch_creation3(I,rw,cl)
        n(1,:,:) = I(rw-1,cl-1,:); % Upper left.  rw = row, cl = column.
        n(2,:,:) = I(rw-1,cl,:); % left.  rw = row, cl = column.
        n(3,:,:) = I(rw-1,cl+1,:); % lower left.  rw = row, cl = column.
        n(4,:,:) = I(rw,cl-1,:); % upper middle.  rw = row, cl = column.
        n(5,:,:) = I(rw,cl+1,:); % lower middle. rw = row, cl = column.
        n(6,:,:) = I(rw+1,cl+1,:); % Lower right .  rw = row, cl = column.
        n(7,:,:) = I(rw+1,cl,:); % right.  rw = row, cl = column.
        n(8,:,:) = I(rw+1,cl-1,:); % upper right.  rw = row, cl = column.
end
