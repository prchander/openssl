marker_size = 14;
line_width = 2;
font_size = 14;
legendPos = 'NorthWest';

color_classical = '#2CBAD4';
color_postquantum = '#7900EF';
color_hybrid = '#F00074';

data = readmatrix('NEW_LOGGED_OPENSSL3.csv');
data_str = readtable('NEW_LOGGED_OPENSSL3.csv');

plot = 4;

%timestamp = data(:,1);
timestamp_seconds = data(:,2);
%algorithm = data(:,3);
algorithm_in_english = string(table2array(data_str(:,4)));
avg_keygen_time = data(:,5);
avg_csr_time = data(:,6);
avg_cert_time = data(:,7);
avg_verifying_time = data(:,8);
% avg_keygen_time = data(:,5) / 10;
% avg_csr_time = data(:,6) / 10;
% avg_cert_time = data(:,7) / 10;
% avg_verifying_time = data(:,8) / 10;
combined_data = [avg_keygen_time avg_csr_time avg_cert_time avg_verifying_time];

maxLim = 0;
if plot == 1
    y = avg_keygen_time;
    maxLim = max(y) * 3;
elseif plot == 2
    y = avg_csr_time;
    maxLim = max(y) * 1.3;
elseif plot == 3
    y = avg_cert_time;
    maxLim = max(y) * 1.3;
elseif plot == 4
    y = avg_verifying_time;
    maxLim = max(y) * 1.1;
end


% Sort
%[y, y_order] = sort(y, 'ascend');
%algorithm_in_english = algorithm_in_english(y_order,:);
set(gcf, 'Position',  [100, 100, 500, 400])

b = bar(y, 'Visible', 'off', 'HandleVisibility', 'off'); % Skeleton
%y = avg_keygen_time;
clset = 0;
pqset = 0;
hyset = 0;
hold on;
for i=1:length(y)
    b_ = bar(i, y(i));
    if i <= 3 % Classical
        set(b_, 'FaceColor', color_classical);
        if clset ~= 0
            set(b_, 'HandleVisibility', 'off');
        end
        clset = 1;
        
    elseif ~contains(algorithm_in_english{i}, '+') % Post quantum
        set(b_, 'FaceColor', color_postquantum);
        if pqset ~= 0
            set(b_, 'HandleVisibility', 'off');
        end
        pqset = 1;
        
    else % Hybrid
        set(b_, 'FaceColor', color_hybrid);
        if hyset ~= 0
            set(b_, 'HandleVisibility', 'off');
        end
        hyset = 1;
    end
end
hold off;

set(gca, 'YScale', 'log');
%ylim([0 maxLim]);
if plot == 1
    ylim([0.999 50000]);
    yticks([0, 1, 10, 100, 1000]);
else
    ylim([0.999 200]);
    yticks([0, 1, 10, 100, 1000]);
end
xlim([0 length(y)+1]);
set(gca,'YTickLabel',num2str(get(gca,'YTick').'));

%xlabel('Algorithm', 'FontSize', font_size);
%xticklabels({'RSA 2048', 'RSA 3072', 'RSA 4096', 'Dilithium 2', 'Dilithium 3', 'Dilithium 4', 'Falcon 512', 'Falcon 1024', 'RSA 3072 - Dilithium 2', 'RSA 3072 - Dilithium 3', 'RSA 3072 - Falcon 512', 'P256 - Dilithium 2', 'P256 - Dilithium 3', 'P384 - Dilithium 4', 'P256 - Falcon 512'});
%xticklabels({'RSA 2048', 'RSA 3072', 'RSA 4096', 'Dilithium 2', 'Dilithium 3', 'Dilithium 5', 'Dilithium2 + AES', 'Dilithium3 + AES', 'Dilithium5 + AES', 'Falcon 512', 'Falcon 1024', 'RSA 3072 + Dilithium 2', 'P256 + Dilithium 2', 'RSA 3072 + Falcon 512', 'P256 + Falcon 512', 'P384 + Dilithium 3', 'P521 + Dilithium 5', 'P521 + Falcon 1024'});
xticks(1:length(algorithm_in_english));
xticklabels(algorithm_in_english);
xtickangle(45);

%ylabel('Time Cost (ms)', 'FontSize', font_size);
if plot == 1
    ylabel('Key-Pair Generation Time (ms)', 'FontSize', font_size);
elseif plot == 2
    ylabel('CSR Generation Time (ms)', 'FontSize', font_size);
elseif plot == 3
    ylabel('Certificate Generation Time (ms)', 'FontSize', font_size);
elseif plot == 4
    ylabel('Certificate Verifying Time (ms)', 'FontSize', font_size);
end
set(gca,'FontSize', font_size);
set(gca, 'YGrid', 'on', 'XGrid', 'off');

legend('Classical', 'Post-quantum', 'Hybrid', 'Location', legendPos)


% if plot == 1
%     set(gca,'YTickLabel',num2str(get(gca,'YTick').'));
% elseif plot == 2
%     set(gca,'YTickLabel',num2str(get(gca,'YTick').'));
% elseif plot == 3
%     set(gca,'YTickLabel',num2str(get(gca,'YTick').'));
% elseif plot == 4
%     set(gca,'YTickLabel',num2str(get(gca,'YTick').'));
% end

%h = text(1:length(y'),y'/1.1,num2str(floor(y)),'color', 'white', 'vert','middle','horiz','right', 'FontSize', font_size); 
h = text(1:length(y'),y'*1.01,num2str(floor(y*100)/100),'vert','middle','horiz','left', 'FontSize', font_size); 
%h = text(1:length(y'),(y')*1.1,num2str(floor(y)),'vert','middle','horiz','center', 'FontSize', font_size); 
set(h,'Rotation', 90);

width = 1500;
height = 500
set(gcf,'position',[100,100,width,height])

%axis square;
%legend('Key generation', 'CSR generation', 'Certificate generation', 'Certificate verification', 'FontSize', font_size);

