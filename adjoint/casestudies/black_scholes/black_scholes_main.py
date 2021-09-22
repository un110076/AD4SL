from black_scholes import *
m=10000
x=[0.5,0.03,0.5,0.4]
y=[0.0]
a_y=[1.0]
a_x=[0.0]*4
a_x=a_black_scholes_call(x,a_x,y,a_y,m)
print(a_x);

y=[0.0]
y=black_scholes_call(x,y,m)
x[3]+=1e-4
yp=[0.0]
yp=black_scholes_call(x,yp,m)
print((yp[0]-y[0])/1e-4)



