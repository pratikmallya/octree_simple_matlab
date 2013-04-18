% Binary tree Implementation in MATLAB
% ====================================
% Second Implementation: Binary tree in 2-d
% Split is in alternate dimensions. First x,
% then y , then x and so on....

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
        splitDim    % 1 = x cordinate, 2 = y cordinate
    end

    methods

        function n = Node(parent, splitDim)
            n.parent = parent;
            n.data = {};
            n.isLeaf = true;
            n.splitDim = splitDim;
        end
        
        function addNewData(n, data)
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
        
        function [nodes] = getNearNodes(root, qNode)
        % return the nodes that are closest to qNode
            if (~root.isLeaf)
                child = whichChild(root, qNode)
                getNearNodes(child, qNode)
            else
                nodes = root.data 
            end
        end

        function splitNode(n)
            sumNode = 0;
            for i = 1:numel(n.data)
                sumNode = sumNode + n.data{i}(n.splitDim);
            end
            n.pivot = sumNode / numel(n.data);
            if (n.splitDim == 1)
                splitDim = 2;
            else
                splitDim = 1;
            end
            n.leftChild  = Node(n, splitDim);
            n.rightChild = Node(n, splitDim);
            for i = 1:numel(n.data)
                child = whichChild(n, n.data{i});
                child.data{end + 1} = n.data{i};
            end
            n.data = {};
        end
        
        function child = whichChild(node, data)
            if (data(node.splitDim) > node.pivot)
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





