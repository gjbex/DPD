#include <stdio.h>
#include <stdlib.h>

#include "tree.h"

Node create_node(double value, int nr_children) {
    Node node;
    node.value = value;
    node.nr_children = nr_children;
    return node;
}

double get_value(Node node) {
    return node.value;
}

void set_value(Node node, double value) {
    node.value = value;
}

int get_nr_children(Node node) {
    return node.nr_children;
}

Node get_child(Node node, int child_nr) {
    return *(node.child[child_nr]);
}

void set_child(Node node, int child_nr, Node child) {
    node.child[child_nr] = &child;
}

void show_r(Node node, char prefix[]) {
    printf("%s%.3f, children: %d\n", prefix, node.value,
           get_nr_children(node));
    char new_prefix[10];
    sprintf(new_prefix, "%s  ", prefix);
    for (int child_nr = 0; child_nr < get_nr_children(node); child_nr++)
        show_r(get_child(node, child_nr), new_prefix);
}

void show(Node node) {
    show_r(node, "");
}

void visit(Node node, double (*transf)(double)) {
    node.value = transf(node.value);
    for (int child_nr = 0; child_nr < get_nr_children(node); child_nr++)
        visit(get_child(node, child_nr), transf);
}
