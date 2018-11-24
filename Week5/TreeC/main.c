#include <stdio.h>

#include "tree.h"

int main() {
    Node *root = create_node(1.0, 3);
    {
        set_child(root, 0, create_node(2.0, 2));
        {
            Node *node = get_child(root, 0);
            set_child(node, 0, create_node(3.0, 0));
            set_child(node, 1, create_node(4.0, 0));
        }
        set_child(root, 1, create_node(5.0, 0));
        {
            // no children
        }
        set_child(root, 2, create_node(6.0, 1));
        {
            Node *node = get_child(root, 2);
            set_child(node, 0, create_node(7.0, 0));
        }
    }
    show(root);
    free_node(root);
    return 0;
}
