function [ data ] = convertArrayList( arrayList )

data = zeros(1,arrayList.size);
for i = 0:arrayList.size-1
    data(i+1) = str2double(arrayList.get(i));
end

end

