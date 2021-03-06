        subroutine bao2d(zbao, H0, Obh2, Och2, ang)
        real*8  H0, Obh2, Och2, ang(14), b1, b2, light_speed
        real*8 zbao(14),DA(14), ad, intval,model, rs, zd
        integer i
        external model,fun

!##############FORTRAN#####################
!# f2py -c -m BAO2D BAO2D.f
!########################################

Cf2py  intent(in)  H0, Obh2, Och2
Cf2py  intent(out) ang
        light_speed = 299792.4580
        b1 = 0.313 * (Obh2 + Och2) ** (-0.419) * (1.0 + 0.607 * (Obh2 
     &  + Och2) ** (0.674))
        b2 = 0.238 * (Obh2 + Och2) ** (0.223)
        zd = (1345.0 * (Obh2 + Och2) ** (0.251) * (1.0 + 
     &   b1 * (Obh2)**(b2)))/(1.0 + 0.659 * (Obh2 + Och2) ** (0.828))
        ad = 1.0/(1.0+zd)

        call QLEG(fun, 1.d-14, ad, H0, Obh2, Och2, rs)

        do i=1,2000
        call QLEG(model,0.d0,zbao(i), H0, Obh2, Och2,intval)
        DA(i)=(light_speed*intval)/(1.0 + zbao(i))
        ang(i)=rs/((1.0+zbao(i))*DA(i))
        enddo


        return
        end


        real*8 function fun(a, H0, Obh2, Och2)
        real*8 y,a,H0, Obh2, Och2,model,Og,Ob,R,cs,light_speed
        external model

	light_speed = 299792.4580
        Og=2.469d-5*(100.0/H0)**2.0
	Ob = Obh2*(100.0/H0)**2
        y = 1.0 / a - 1.0
	

        R=(3.0*Ob)/(4.0*Og/a)
        cs=light_speed/(sqrt(3.0*(1.0+R)))/a/a
        fun = cs*model(y, H0, Obh2, Och2)
        

        return
        end function


        real*8 function model(z, H0, Obh2, Och2)
        real*8 z, H0, Obh2, Och2, Om, Orr, denom, Ox, y, h

	y = 1.0 + z
        h = H0 / 100.0
    	Om = (Obh2 + Och2) / h ** 2
	Orr = (2.469e-5) * (h ** (-2.0)) * (1.0 + 
     &    ((7.0 / 8.0) * (4.0 / 11.0) ** (4.0 / 3.0)) * 3.046)
        Ox = 1.0 - Orr - Om
        denom=Orr*y**(4.0) + Om*y**(3.0) + Ox

  
        model = 1.0/(H0*sqrt(denom))

        return
        end function

  


      SUBROUTINE QLEG(FUN, A, B, H0, Obh2, Och2, SS)
!--------------------------------------------------------------------
!  Comment: Returns as SS the integral from A to B of               |
!                           FUN(X)                                  |
!           by 80-point Gauss-Legendre integration.                 |
!  Date   : 22-March-1990                                           |
!--------------------------------------------------------------------
      IMPLICIT REAL*8 (A-H,O-Z)
!                               the abscissas and weights
      DIMENSION X(40), W(40)
      DATA X /    .195113832567940D-01,    .585044371524207D-01,
     &              .974083984415846D-01,    .136164022809144D+00,
     &              .174712291832647D+00,    .212994502857666D+00,
     &              .250952358392272D+00,    .288528054884512D+00,
     &              .325664370747702D+00,    .362304753499487D+00,
     &              .398393405881969D+00,    .433875370831756D+00,
     &              .468696615170545D+00,    .502804111888785D+00,
     &              .536145920897132D+00,    .568671268122710D+00,
     &              .600330622829752D+00,    .631075773046872D+00,
     &              .660859898986120D+00,    .689637644342028D+00,
     &              .717365185362100D+00,    .744000297583597D+00,
     &              .769502420135041D+00,    .793832717504606D+00,
     &              .816954138681464D+00,    .838831473580255D+00,
     &              .859431406663111D+00,    .878722567678214D+00,
     &              .896675579438771D+00,    .913263102571758D+00,
     &              .928459877172446D+00,    .942242761309873D+00,
     &              .954590766343635D+00,    .965485089043799D+00,
     &              .974909140585728D+00,    .982848572738629D+00,
     &              .989291302499756D+00,    .994227540965688D+00,
     &              .997649864398238D+00,    .999553822651631D+00 /
      DATA W /    .390178136563067D-01,    .389583959627695D-01,
     &              .388396510590520D-01,    .386617597740765D-01,
     &              .384249930069594D-01,    .381297113144776D-01,
     &              .377763643620014D-01,    .373654902387305D-01,
     &              .368977146382760D-01,    .363737499058360D-01,
     &              .357943939534161D-01,    .351605290447476D-01,
     &              .344731204517539D-01,    .337332149846115D-01,
     &              .329419393976454D-01,    .321004986734878D-01,
     &              .312101741881147D-01,    .302723217595580D-01,
     &              .292883695832679D-01,    .282598160572769D-01,
     &              .271882275004864D-01,    .260752357675651D-01,
     &              .249225357641155D-01,    .237318828659301D-01,
     &              .225050902463325D-01,    .212440261157820D-01,
     &              .199506108781420D-01,    .186268142082990D-01,
     &              .172746520562693D-01,    .158961835837257D-01,
     &              .144935080405091D-01,    .130687615924013D-01,
     &              .116241141207978D-01,    .101617660411029D-01,
     &              .868394526926027D-02,    .719290476811493D-02,
     &              .569092245139042D-02,    .418031312469486D-02,
     &              .266353358951271D-02,    .114495000318697D-02 /
      C=(B-A)/2.D0
      D=(B+A)/2.D0
      SS=0.D0
      DO 10 I=1,40
      Y=C*X(I)+D
10      SS=SS+W(I)*FUN(Y, H0, Obh2, Och2)
      DO 20 I=1,40
      Y=-C*X(I)+D
20      SS=SS+W(I)*FUN(Y, H0, Obh2, Och2)
      SS=C*SS
      RETURN
      END
