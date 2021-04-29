import pandas as pd
entrada="Testset_classified_kmeans_euclidean_k5.csv"
saida="saidaRLE_classified_kmeans_euclidean_k5.txt"


df = pd.read_csv(entrada)


vetorSAIDA=[]
#count=0

aux='nil'
c=1
for i in range (len(df['categoria'])):
    if (df['categoria'][i]==aux):
        c=c+1
    else:
        if(aux!='nil'):
            print(c,':',aux)
            vetorSAIDA.append(str(c)+':'+str(aux))
            #count=count+c
        c=1
        aux=df['categoria'][i]
        


#print(count)
with open(saida, 'w') as f:
    for item in vetorSAIDA:
        f.write("%s\n" % item)