% % Author:Rinu Sebastian 
% % Course work: EE592
% % Project: Object removal and infilling 


clear all;
close all;
A=imread('Ps.jpg');
C = imresize(A,0.1); 
D=C;
[row,col,dim]=size(C);
data1='Mask_data.mat';
data2='Mask_data_cp.mat';
mask1=importdata(data1);
mask =importdata(data2);



imwrite(mask,'Mask.jpg');
mask1(:,:,2) = mask;
mask1(:,:,3) = mask(:,:,1);
ROI = C;
ROI(mask1 == 0) = 0;
imwrite(ROI,'ROI.jpg');
grey=rgb2gray(ROI); 
ROI_n = adapthisteq(grey,'clipLimit',0.009,'Distribution','uniform');
iso=[];
[I, theta] = isophote(C,0.012); 

%Initial


%finding boundary pixels
boundaries = bwboundaries(grey);



x = boundaries{1}(:, 2);
y = boundaries{1}(:, 1);

% figure(9)
% plot(xk,-yk,'b.');hold on;
% plot(39,-191,'g*');
tic

cont=[x,y];

% figure(4)
% plot(x,-y,'b.');

%area = polyarea(x,y);
orderedpair=[];
for i=1:row
    for j=1:col
        orderedpair=[orderedpair; [i,j]];
    end
end

%known region by taking out boundary x,y's from ordered pair x,y's.
known=unique(setdiff(orderedpair,cont,'rows'),'rows'); 

conf=ones(row,col);
cont_sort=sortrows(cont,2);
uni_cont=unique(cont_sort(:,2));
fill=[];
for i=uni_cont(1):uni_cont(end)
    k=cont_sort(cont_sort(:,2)==i);
    b=setdiff(k(1):1:k(end),k);
    if isempty(b)
        continue;
    end
      clear b1;
    b1(:,1)=b;
    b1(:,2)=i*ones(size(b));
    fill=[fill;b1];
end

for i=1:length(fill)
    x4=fill(:,2);
    y4=fill(:,1);
    conf(x4(i),y4(i))=0;
end

for fr=1:20
clear cont
clear P;
close all;
cont=[x,y];

% normals at any point in boundary
dy = gradient(y);
dx = gradient(x);
dx(dx==0)=0.01;
%quiver(x(1),y(1),-dy(3),dx(3))
norml= -dy./dx;

%%

for v=1:length(cont)
    x=cont(:,1);
    y=cont(:,2);
    
    iso(v)=I(x(v),y(v));
    data_t(v)=abs(dot(iso(v)',norml(v)))/255; 
    r=x(v);
    c=y(v);
    pixel_pos=[r-1,c-1; r-1,c; r-1,c+1; r,c-1; r,c; r,c+1;r+1,c-1; r+1,c; r+1,c+1];
% Patch values 
    %n=patch_creation(C,r,c);

% figure(2);
% imshow(C);hold on
% %plot(n,'g*')
    k=rectangle('Position',[r-1 c+1 3 3]);
    patch_n=9;
    sum=0;
    for w=1:9
        x0=pixel_pos(w,1);y0=pixel_pos(w,2);
            if ismember(pixel_pos(w,:),cont,'rows') || ismember(pixel_pos(w,:),fill,'rows')
                sum = sum+conf(x0,y0);
            end
    end
    conf(r,c)=sum/patch_n;
   
    P(v)=conf(r,c)*data_t(v);
end

% sort_P=sort(P);
% sort_P=sort_P(find(sort_P~=0));

        
in_Pmax=find(P==max(P));
if v>=2
    if x(v)==x(v-1) &&y(v)==y(v-1)
        in_Pmax=find(P==max(P(P~=max(P))));
    end
end
cont_max=cont(in_Pmax,:);
patch_p=patch_creation3(C,cont_max(1,1),cont_max(1,2));
% figure(3)
% imshow(C);hold on
% plot(cont_max(1,1),cont_max(1,2),'g*')
% [x_q,y_q,z_q]=find(C==C(cont_max(1,1),cont_max(1,2),:));
% ind_q =[x_q,y_q,z_q];

for ir=1:length(known)
    if known(ir,1)==1 || known(ir,2)==1
        ssd(ir)=NaN;
        continue;
    elseif known(ir,1)==row || known(ir,2)==col
        ssd(ir)=NaN;
        break;
    else
        patch_q_test=patch_creation3(C,known(ir,1),known(ir,2));
        ssd(ir)= immse(patch_p, patch_q_test) * numel(patch_p);
    end
end

jk1=known(ssd==min(ssd),:);
D=patch_replace3(D,jk1(1),jk1(2),cont_max(1),cont_max(2));
subplot 121
imshow(C);
subplot 122
imshow(D);

%boundary shifting

in=find(ismember(cont,[cont_max(1),cont_max(2)],'rows'));clear temp5;
temp5=zeros(9,2);
       % disp(['Median_x, median_y, x_max, y_max=' ,num2str(round(median(x))),',', num2str(round(median(y))), ',',num2str(cont_max(1)),',', num2str(cont_max(2))]);
       % if cont_max(1)<=round(median(x))
           temp5(1,:)=[x(in)-1,y(in)-1];
           temp5(2,:)=[x(in)-1,y(in)];
           temp5(3,:)=[x(in)-1,y(in)+1];
       %
           temp5(4,:)=[x(in),y(in)-1];
           temp5(5,:)=[x(in),y(in)];
           temp5(6,:)=[x(in),y(in)+1];
       % cont_max(2)<=round(median(y))
           temp5(7,:)=[x(in)+1,y(in)-1];
           temp5(8,:)=[x(in)+1,y(in)];
           temp5(9,:)=[x(in)+1,y(in)+1];
           disp(temp5)
  temp=[];
      for ig=1:9
        sz(ig)=length(find(ismember(cont,temp5(ig,:),'rows')));
      end
      temp5(find(sz==1),:)=[];
          if cont_max(1)<=round(median(x))
              if cont_max(2)<=round(median(y))
                  temp=[temp;temp5(temp5(:,1)>cont_max(1),:)];
              end
          elseif cont_max(2)<=round(median(y))
                  temp=[temp;temp5(temp5(:,1)<cont_max(1),:)];
          else
              temp=[temp;temp5(temp5(:,2)>=cont_max(2),:)];
          end
       for ik=1:length(temp)
           if temp(ik,1)<round(median(x))
              cont(cont(:,1) < temp(ik,1)& cont(:,2)==temp(ik,2),:) = [];
           elseif temp(ik,1)>round(median(x))
                 temp=[temp; cont(cont(:,2)==temp(ik,2),:)]
                 cont(cont(:,2)==temp(ik,2),:)=[];
                 temp=sort(temp,1,'descend');
                 temp(abs(diff(temp(:,1)))<3,:)=[];
                 break;
           end 
       end
      cont=[cont;temp];    
      clear x;
      clear y;
x=cont(:,1);
y=cont(:,2);


area = polyarea(x,y);
disp(['Area=',num2str(area)]);
close all;
figure(4)
plot(x,-y,'b.');
hold on

fileID = fopen('kxop.txt','a+');
formatSpec0 ='\r\nIter:%d';
fprintf(fileID,formatSpec0,fr);
formatSpec = '\r\nMedian_x, median_y, x_max, y_max= %3.0f,%3.0f,%3.0f,%3.0f';
fprintf(fileID,formatSpec,round(median(x)),round(median(y)),cont_max(1),cont_max(2));
formatSpec2 = '\r\nArea= %6.1f';
fprintf(fileID,formatSpec2,area);
fclose(fileID);
end
elapsed =toc


            
