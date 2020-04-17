# Una vez ponderadas las redes, puede calcularse el
# Coeficiente de Clusterización de cada una de ellas.

# Cargar library
library(igraph)

# De acuerdo a tus necesidades, podés calcular
# coeficiente global, promedio o local.

G = graph_from_data_frame(d = edge_list, vertices = node_list, directed = FALSE)
    transitivity(G, type="global")
    transitivity(G, type= "average")
    transitivity(G, type="local")
