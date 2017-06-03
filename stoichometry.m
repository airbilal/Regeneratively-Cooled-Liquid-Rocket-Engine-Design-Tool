function stoich=stoichometry(fuel,oxidizer,combustionproduct)
%This function balances the chemical equation to find 
%stoichiometric oxidizer-fuel ratio
combustionproduct(1).composition=[combustionproduct(1).carbon ...
    combustionproduct(1).oxygen combustionproduct(1).nitrogen combustionproduct(1).hydrogen]';
combustionproduct(2).composition=[combustionproduct(2).carbon ...
    combustionproduct(2).oxygen combustionproduct(2).nitrogen combustionproduct(2).hydrogen]';
stoich.A=[fuel(1).composition oxidizer.composition...
    -combustionproduct(1).composition -combustionproduct(2).composition];
stoich.A(end+1,:)=[1,zeros(1,length(stoich.A)-1)];

stoich.A( ~any(stoich.A,2), : ) = [];  %rows
stoich.A( :, ~any(stoich.A,1) ) = [];  %columns
stoich.B=[zeros(length(stoich.A)-1,1);1];
stoich.C=stoich.A\stoich.B;
sprintf('%s + %2.1f(%s) ---> %2.1f(%s) + %2.1f(%s)',fuel(1).formula,...
    stoich.C(2),oxidizer.formula,stoich.C(3),combustionproduct(1).formula,...
    stoich.C(4),combustionproduct(2).formula)

stoich.OF=stoich.C(2)/fuel(1).molecularmass*oxidizer.molecularmass;

sprintf('The stoichometric oxidizer (%s) to fuel (%s) ratio is %2.2f',...
    oxidizer.name,fuel(1).name,stoich.OF)