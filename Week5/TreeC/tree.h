#ifndef TREE_HDR
#define TREE_HDR

struct node {
    double value;
    int nr_children;
    struct node **child;
};

typedef struct node Node;

Node *create_node(double value, int nr_children);
double get_value(Node *ndoe);
void set_vallue(Node *node, double value);
int get_nr_children(Node *node);
Node *get_child(Node *node, int child_nr);
void set_child(Node *node, int child_nr, Node *child);
void show(Node *node);
void visit(Node *node, double (*transf)(double));
void free_node(Node *node);

#endif
