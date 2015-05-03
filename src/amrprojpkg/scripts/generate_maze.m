% maze = generate_maze(X,Y)
% By Jeremy Kubica, Copyright 2003
%
% Generates a valid maze of the given size (Currently a very
% slow version).
%
% Type 'help maze' for more information
function maze = generate_maze(X,Y)

% create the maze
maze = create_blank_maze(X,Y);

% allocate space for a collection of sets
sets = 1:(X*Y);

% while there are disjoint sets left...
while(max(sets) > 1)
   
   % find out how many sets are left
   L = max(sets);
    
    % pick a set and a cell from it
    set_ind = floor(rand(1,1) * L) + 1;
    set = find(sets == set_ind);
    cell_ind = floor(rand(1,1) * length(set)) + 1;
    cell = set(cell_ind);
    
    % find the coordinates of the cell
    cX = ceil(cell / Y);
    cY = mod(cell, Y);
    if(cY == 0)
       cY = Y;
    end
    
    % pick a random direction to try merging
    dir = floor(rand(1,1) * 4.0) + 1;
    cellNeighbor = 0;
    
    switch floor(dir)
        case 1
            cellNeighbor = cell - 1;
            nY = cY - 1;
            nX = cX;
        case 2
            cellNeighbor = cell + Y;
            nY = cY;
            nX = cX + 1;
        case 3
            cellNeighbor = cell + 1;
            nY = cY + 1;
            nX = cX;
        case 4
            cellNeighbor = cell - Y;
            nY = cY;
            nX = cX - 1;
         end
   
    % if a valid neighbor was found... find out which
    % set it is currently in.
    neigh_set = set_ind;
    if((nX <= X) & (nX > 0) & (nY <= Y) & (nY > 0))
       neigh_set = sets(cellNeighbor);
    end

    % If the two sets are different merge
    if(neigh_set ~= set_ind)
             
       % merge the sets
       inds = find(sets == neigh_set);
       sets(inds) = set_ind * ones(1,length(inds));
       
       % shift everything down 1
       inds = find(sets >= neigh_set);
       sets(inds) = sets(inds) - 1;
        
        % open the "wall" in the maze
        switch floor(dir)
            case 1
                maze.adjacent(cell,1) = 1;
                maze.adjacent(cellNeighbor,3) = 1;
            case 2
                maze.adjacent(cell,2) = 1;
                maze.adjacent(cellNeighbor,4) = 1;
            case 3
                maze.adjacent(cell,3) = 1;
                maze.adjacent(cellNeighbor,1) = 1;
            case 4
                maze.adjacent(cell,4) = 1;
                maze.adjacent(cellNeighbor,2) = 1;
             end
             
             %[cell cellNeighbor dir cX cY nX nY L]
             
             %draw_maze(maze,1);
             %pause;
        
    end
    
end
