struct node {
    int value;
    struct node * next;
};
typedef struct node List;


int is_empty(List *);
int length(List *);

List *add_node(List *,  int);
List *create_node(int);
List *remove_node(List *, int); 
int find_nth(List *, int n);

char *tostring(List *);


