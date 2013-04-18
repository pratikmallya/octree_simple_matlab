% Binary tree Implementation in MATLAB
% ====================================
% First Implementation: Binary tree in one-d 


% MATLAB does not have a facility for pointers, we 
% have to rely on an indexing scheme (which is what
% pointers do, if you think about it)

classdef Node < handle
    properties
        MAXDATA = 5;
        parent          
        leftChild       
        rightChild
%        nData       % no of data points in node
        data        % cell array of data
    end
    
    properties (SetAccess = private)
        pivot
        isLeaf
    end

    methods
        function n = Node(parent)
            n.parent = parent;
            n.data = {};
            n.isLeaf = true;
        end
        
        function addNewData(n, data)
            if (~n.isLeaf)
                child  = whichChild(n, data);
                addNewData(child, data);
            else
                n.data{end + 1} = data;
                if (numel(n.data) == n.MAXDATA)
                    n.isLeaf = false;
                    splitNode(n);
                end
            end    
        end
        
        function splitNode(n)
            sumNodeRandomOpt = 0;
            for i = 1:numel(n.data)
                sumNodeRandomOpt = sumNodeRandomOpt + n.data{i};
            end
            n.pivot = sumNodeRandomOpt / numel(n.data);
            n.leftChild  = Node(n);
            n.rightChild = Node(n);
            for i = 1:numel(n.data)
                child = whichChild(n, n.data{i});
                child.data{end + 1} = n.data{i};
            end
            n.data = {};
        end
        
        function child = whichChild(node, data)
                if (data > node.pivot)
                    child = node.rightChild;
                else
                    child = node.leftChild;
                end
        end
    end
end





