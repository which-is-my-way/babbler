[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 10
  xmax = 0.304
  ymax = 0.0257
[]

[Problem]
  type = FEProblem
  coord_type = RZ
  rz_coord_axis = X
[]

[Variables]
  [pressure]
  []
[]

[Kernels]
  [diffusion]
    type = DarcyPressure
    variable = pressure
    #permeability = 0.8451e-09
    #viscosity = 0
  []
[]

[Materials]
  [filter]
    type = PackedColumn # Provides permeability and viscosity of water through packed 1mm spheres
  []
[]

[AuxVariables]
  [velocity]
    order = CONSTANT # Since "pressure" is approximated linearly, its gradient must be constant
    family = MONOMIAL_VEC # A monomial interpolation means this is an elemental AuxVariable
  []
[]

[AuxKernels]
  [velocity]
    type = DarcyVelocity
    variable = velocity # Store volumetric flux vector in "velocity" variable from above
    pressure = pressure # Couple to the "pressure" variable from above
    execute_on = TIMESTEP_END # Perform calculation at the end of the solve step - after Kernels run
  []
[]

[BCs]
  [inlet]
    type = ADDirichletBC
    variable = pressure
    boundary = left
    value = 4000
  []
  [outlet]
    type = ADDirichletBC
    variable = pressure
    boundary = right
    value = 0
  []
[]

[Executioner]
  type = Steady
  solve_type = NEWTON

  petsc_options_iname = '-pc_type  -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true
[]
