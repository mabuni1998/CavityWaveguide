@testset "Single detector click" begin
    param = BarretKokParameters()
    param.times = 0:0.1:30
    param.γ = 0
    sys = prep_fast(param)
    bc = sys.bc
    bw = sys.bw
    be = sys.be

    ξfun(t,σ,t0) = complex(sqrt(2/σ)* (log(2)/pi)^(1/4)*exp(-2*log(2)*(t-t0)^2/σ^2))
    psi_a_1 = onephoton(bw,ξfun,param.times,1,15) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,1)
    psi_b_1 = zerophoton(bw) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,2)
    psi_a_2 = zerophoton(bw) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,2)
    psi_b_2 = onephoton(bw,ξfun,param.times,1,15) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,1)
    proj_up = zerophoton(bw) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,2)
    proj_down = zerophoton(bw) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,1)

    p1 = LazyTensorKet(proj_up,proj_down)
    p2 = LazyTensorKet(proj_down,proj_up)

    psi1 = LazyTensorKet(psi_a_1,psi_b_1)
    psi2 = LazyTensorKet(psi_a_2,psi_b_2)

    Detector_plus = Detector(sys.wa/sqrt(2),sys.wb/sqrt(2))
    Detector_minus = Detector(sys.wa/sqrt(2),-sys.wb/sqrt(2))

    @test isapprox(detect_single_click(psi1,Detector_plus,p2),0.5)
    @test isapprox(detect_single_click(psi1,Detector_plus,p2),0.5)
    @test isapprox(detect_single_click(psi1,Detector_minus,p2),0.5)
    @test isapprox(detect_single_click(psi2,Detector_plus,p1),0.5)
    @test isapprox(detect_single_click(psi2,Detector_minus,p1),0.5)
    @test isapprox(detect_single_click(psi1,Detector_plus,p1)+1,1)
    @test isapprox(detect_single_click(psi1,Detector_minus,p1)+1,1)
    @test isapprox(detect_single_click(psi2,Detector_plus,p2)+1,1)
    @test isapprox(detect_single_click(psi2,Detector_minus,p2)+1,1)


    psi_plus = (psi1+psi2)/sqrt(2)
    psi_minus = (psi1-psi2)/sqrt(2)
    projector_plus = (p1+p2)/sqrt(2)
    projector_minus = (p1-p2)/sqrt(2)

    @test isapprox(detect_single_click(psi_plus,Detector_plus,projector_plus),0.5)
    @test isapprox(detect_single_click(psi_plus,Detector_minus,projector_minus),0.5)
    @test isapprox(detect_single_click(psi_plus,Detector_plus,projector_minus)+1,1)
    @test isapprox(detect_single_click(psi_plus,Detector_minus,projector_plus)+1,1)

    @test isapprox(detect_single_click(psi_minus,Detector_plus,projector_plus)+1,1)
    @test isapprox(detect_single_click(psi_minus,Detector_minus,projector_minus)+1,1)
    @test isapprox(detect_single_click(psi_minus,Detector_plus,projector_minus),0.5)
    @test isapprox(detect_single_click(psi_minus,Detector_minus,projector_plus),0.5)
end

@testset "Double detector click" begin
    param = BarretKokParameters()
    param.times = 0:0.1:30
    param.γ = 0
    sys = prep_fast(param)
    bc = sys.bc
    bw = sys.bw
    be = sys.be

    Detector_plus = Detector(sys.wa/sqrt(2),sys.wb/sqrt(2))
    Detector_minus = Detector(sys.wa/sqrt(2),-sys.wb/sqrt(2))

    ξfun(t,σ,t0) = complex(sqrt(2/σ)* (log(2)/pi)^(1/4)*exp(-2*log(2)*(t-t0)^2/σ^2))
    psi_a_1 = onephoton(bw,ξfun,param.times,1,15) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,1)
    psi_b_1 = zerophoton(bw) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,2)
    psi_a_2 = zerophoton(bw) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,2)
    psi_b_2 = onephoton(bw,ξfun,param.times,1,15) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,1)
    proj_up = zerophoton(bw) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,2)
    proj_down = zerophoton(bw) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,1)

    p1 = LazyTensorKet(proj_up,proj_down)
    p2 = LazyTensorKet(proj_down,proj_up)
    projector_plus = (p1+p2)/sqrt(2)
    projector_minus = (p1-p2)/sqrt(2)
    psi_two_photons = LazyTensorKet(psi_a_1,psi_b_2)
    p_down_down = LazyTensorKet(proj_down,proj_down)

    @test isapprox(detect_double_click(psi_two_photons,Detector_plus,Detector_plus,p_down_down),0.5)
    @test isapprox(detect_double_click(psi_two_photons,Detector_minus,Detector_minus,p_down_down),0.5)
    @test isapprox(detect_double_click(psi_two_photons,Detector_plus,Detector_minus,p_down_down)+1,1)
    @test isapprox(detect_double_click(psi_two_photons,Detector_minus,Detector_plus,p_down_down)+1,1)
    @test isapprox(detect_double_click(psi_two_photons,Detector_minus,Detector_minus),0.5)
    @test isapprox(detect_double_click(psi_two_photons,Detector_plus,Detector_plus),0.5)


    psi_1_up = onephoton(bw,ξfun,param.times,1,15) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,2)
    psi_1_down = onephoton(bw,ξfun,param.times,1,15) ⊗ fockstate(bc,0) ⊗ nlevelstate(be,1)
    psi_two_photons_entangled = LazySumKet(LazyTensorKet(psi_1_up,psi_1_down),LazyTensorKet(psi_1_down,psi_1_up))/sqrt(2)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_minus,Detector_minus,projector_plus),0.5)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_minus,Detector_minus,projector_plus),0.5)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_minus,Detector_minus),0.5)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_minus,Detector_plus)+1,1)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_plus,Detector_minus)+1,1)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_plus,Detector_plus),0.5)

    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_minus,Detector_minus,p1),0.25)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_minus,Detector_minus,p2),0.25)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_plus,Detector_plus,p1),0.25)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_plus,Detector_plus,p2),0.25)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_minus,Detector_plus,p1)+1,1)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_plus,Detector_minus,p2)+1,1)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_plus,Detector_minus,p1)+1,1)
    @test isapprox(detect_double_click(psi_two_photons_entangled,Detector_minus,Detector_plus,p2)+1,1)
end