function comp=hamming(J,Codesize)

counter=zeros(1,Codesize);

length=size(J,2);
for i=1:length
    a=J(1,i);
    J(i);
    counter(J(i))=counter(J(i))+1;
end

sum(counter)

probs=zeros(1,Codesize);
length2=size(counter,2);
for i=1:length2
    probs(i)=counter(i)/length;
end

    
a=sort(probs, 'descend');
a=a';

symbols=[1:Codesize];
[dict,avglen] = huffmandict(symbols,probs); % Create dictionary.
comp = huffmanenco(J',dict); % Encode the data.
