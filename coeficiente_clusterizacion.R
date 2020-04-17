# Una vez construido el plot, puede calcularse el
# Coeficiente de clusterización de cada red.

# Cargar library
library(igraph)

# Puede calcularse el coeficiente global, promedio o local.

G = graph_from_data_frame(d = edge_list, vertices = node_list, directed = FALSE)
    transitivity(G, type="global")
    transitivity(G, type= "average")
    transitivity(G, type="local")
