syms x1 y1 R a R1 r1_c1 a1 R2 r1_c2 a2 ox oy x2 y2 r2_c1 r2_c2 a_i L

%a1=a2;
eqns = [(R1+r1_c1)^2 + (R1+r2_c1)^2 - 2*(R1+r1_c1)*(R1+r2_c1)*cos(a1) == (R1+r1_c2)^2 + (R1+r2_c2)^2 - 2*(R1+r1_c2)*(R1+r2_c2)*cos(a2)];
%eqns = [(R1+r1_c1)^2 + (R1+r2_c1)^2 - 2*(R1+r1_c1)*(R1+r2_c1)*cos(a1) == (R1+r1_c2)^2 + (R1+r2_c2)^2 - 2*(R1+r1_c2)*(R1+r2_c2)*cos(a1)];
%[A,b] = equationsToMatrix(eqns,R1)
S=solve(eqns,R1);
%simplify(S);

matlabFunction(S,'File','solveR.m');
%
% eqns = [x1 == (R1+r1_c1)*cos(a1)
%     y1 == (R1+r1_c1)*sin(a1)
%     x1 == (R2+r1_c2)*cos(a2)+ox
%     y1 == (R2+r1_c2)*sin(a2)+oy
%     x2 == (R1+r2_c1)*cos(a1+30/sym(pi))
%     y2 == (R1+r2_c1)*sin(a1+30/sym(pi))
%     x2 == (R2+r2_c2)*cos(a2+30/sym(pi))+ox
%     y2 == (R2+r2_c2)*sin(a2+30/sym(pi))+oy];
% vars = [R1 a1 R2 a2 ox oy];
% S=solve(eqns,vars);
%
% eqns = [x1 == (R+r1_c1)*cos(a)
%         y1 == (R+r1_c1)*sin(a)
%         x1 == (R+r1_c2)*cos(a)+ox
%         y1 == (R+r1_c2)*sin(a)+oy
%         x2 == (R+r2_c1)*cos(a+30/)
%         y2 == (R+r2_c1)*sin(a+30/)
%         x2 == (R+r2_c2)*cos(a+30/)+ox
%         y2 == (R+r2_c2)*sin(a+30/)+oy];
%         vars = [R a ox oy];
%          S=solve(eqns,vars)
    
%     eqns = [(r1_c2)*cos(a2)+ox == (r1_c1)*cos(a1)
%      (r1_c1)*sin(a1) == (r1_c2)*sin(a2)+oy
%     (r2_c1)*cos(a1+sym(30/pi)) == (r2_c2)*cos(a2+sym(30/pi))+ox
%     (r2_c1)*sin(a1+sym(30/pi)) == (r2_c2)*sin(a2+sym(30/pi))+oy];
%     vars = [a ox oy];
%     S=solve(eqns,vars);
%     
%     
    % syms a b c
    %
    % eqns =[a == R+b
    %         a == R+c+ox];
    %  vars = [R ox];
    % S = solve(eqns,vars);
    %S = solve(a == R+b, a == R+c+ox,[R ox]);
    
%     syms a1 b1 c1 a2 b2 c2 d1 d2 e f
%     eqns =[a1+b1+c1 == 180
%         a2+b2+c2 == 180
%         c1==d2+c2
%         b2==b1+d1
%         a1+e+d2==180
%         a2+e+d1==180
%         f+e == 180
%         f+c2+b1 ==180];
%     s=solve(eqns,[a1 b1 c1 b2 c2 d1 d2 e f])    
