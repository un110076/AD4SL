from speelpenning import *
n=10
x=[0.5]*n
y=[0.0]
a_y=[1.0]
a_x=[0.0]*n
a_x=a_speelpenning(x,a_x,y,a_y,n)
print(a_x);

y=[0.0]
y=speelpenning(x,y,n)
x[6]+=1e-4
yp=[0.0]
yp=speelpenning(x,yp,n)
print((yp[0]-y[0])/1e-4)



