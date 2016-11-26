function q = my_rotate_z(p, phi)

    % Q = ROTATE_Z(P, PHI) Rotate around z axis
    % This function rotates the point P (in some coordinate system) around the
    % z axis in the positive direction by an angle PHI [rad].
    %
    % Both P and Q are _row vectors_ , PHI is a scalar
    
    
    rotation_matrix = [cos(phi), sin(phi), 0; ...
                       -sin(phi), cos(phi), 0; ...
                       0, 0, 1];
    
    q = rotation_matrix*transpose(p);

end % function rotate_z()
