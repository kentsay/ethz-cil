function new_mask = remask( I_rec,mask )
tmp_mask = mask == 0;
B = edge(I_rec,'Canny');
new_mask = ~(B&tmp_mask);
end

