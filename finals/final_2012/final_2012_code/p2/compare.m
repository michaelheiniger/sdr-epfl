subframes_c = correction();

my_subframes = my_sol();

if (subframes_c == my_subframes)
    display('ok');
else 
    display('fuck');
end