using GLMakie
using LinearAlgebra
LinAlg = LinearAlgebra

Laska.mad!(res)
Laska.cv2(res, true)
Laska.medianisi!(res)

g, s, a = Laska.clustergraph(res, ["mad", "cv2median", "median_isi", "fr"], 10)

A = collect(Laska.normalizedlaplacian(g))
eig = LinAlg.eigvecs(A)
eigvals = LinAlg.eigvals(A)

# Cluster with DBSCAN https://ai.stanford.edu/~ang/papers/nips01-spectral.pdf
eigenmatr = eig[:, 1:4]
for col in 1:4
    eigenmatr[:, col] = Laska.normalize(eigenmatr[:, col])
end

trans = transpose(eigenmatr)
db = Clustering.dbscan(trans, 0.2)

fig = Figure()
ax = Axis3(
    fig[1, 1],
    xlabel="mad",
    ylabel="fr",
    zlabel="cv2"
)
text!(
    ax,
    Laska.normalize(res._info[!, "mad"]),
    Laska.normalize(res._info[!, "fr"]),
    Laska.normalize(res._info[!, "cv2median"]),
    text=repr.(s) .* ":" .* repr.(db.assignments),
    color=db.assignments
)
display(fig)


