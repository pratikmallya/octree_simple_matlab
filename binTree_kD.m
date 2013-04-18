% Binary tree Implementation in MATLAB
% ====================================
% Third Implementation: Binary tree in k-d
% Split is in alternate dimensions. First x1,
% then x2 , then x3 and so on....

% All elements are stored in the leaves, the interior
% nodes are basically redirection points

% MATLAB does not have a facility for pointers, but
% it does have this 'handle' class which behaves 
% similarly

classdef Node < handle
    properties
        MAXDATA = 3;
        parent          
        leftChild       
        rightChild
        data        % cell array of data
    end
    
    properties (SetAccess = private)
        pivot       % the value of a dimension along which it's split
        isLeaf      % is this node a leaf?
        splitDim    % 0 = x1 cordinate, 1 = x2 cordinate, ...
        k           % dimension of this k-d Tree
    end

    methods
        function n = Node(parent, splitDim, k)
            if (splitDim >= 0 & k >= splitDim)
                n.parent = parent;
                n.data = {};
                n.isLeaf = true;
                n.splitDim = splitDim;
                n.k = k;
            else
                error('There is something wrong with k or splitDim');
            end
        end
        
        function addNewData(n, data)
            if (numel(data) ~= n.k)
                error('The dim of node is %d, while that of data is %d',n.k,numel(data));
            end
            if (~n.isLeaf)
                child  = whichChild(n, data);
                addNewData(child, data);
            else
                n.data{end + 1} = data;
                if (numel(n.data) > n.MAXDATA)
                    n.isLeaf = false;
                    splitNode(n);
                end
            end    
        end
        
        function splitNode(n)
            sumNode = 0;
            
            for i = 1:numel(n.data)
                sumNode = sumNode + n.data{i}(n.splitDim + 1);
            end
            n.pivot = sumNode / numel(n.data);
            splitDim = mod(n.splitDim + 1 , n.k);
            n.leftChild  = Node(n, splitDim, n.k);
            n.rightChild = Node(n, splitDim, n.k);
            for i = 1:numel(n.data)
                child = whichChild(n, n.data{i});
                child.data{end + 1} = n.data{i};
            end
            n.data = {};
        end
        
        function child = whichChild(node, data)
            if (data(node.splitDim + 1) > node.pivot)
                child = node.rightChild;
            else
                child = node.leftChild;
            end
        end
        
        function printBinaryTree(node)
            if (node.isLeaf)
                disp(sprintf('pivot is %s', node.pivot));
            else
                printBinaryTree(node.leftChild);
                printBinaryTree(node.rightChild);
            end
        end
    end
end
