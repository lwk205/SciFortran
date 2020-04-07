!HYBRD INTERFACE:
!solve N nonlinear equations in N unknowns
!numerical jacobian 
subroutine fsolve_hybrd_func(func,x,tol,info)
  interface
     function func(x)
       real(8),dimension(:),intent(in) :: x
       real(8),dimension(size(x))      :: func
     end function func
  end interface
  real(8),dimension(:)       :: x      
  real(8),optional           :: tol
  integer,optional           :: info
  real(8)                    :: tol_
  integer                    :: info_
  integer                    :: n
  real(8),dimension(size(x)) :: fvec
  tol_ = 1.d-15;if(present(tol))tol_=tol
  n=size(x)
  call hybrd1(fsolve_hybrd1_func2sub,n,x,fvec,tol_,info_)
  if(present(info))info=info_
  select case(info_)
  case default
     return
  case(0)
     write(*,*)"FSOLVE STOP: improper input parameters."
  case(1)
     write(*,*)"FSOLVE STOP: the relative error between X and the solution is at most TOL."
  case(2)
     write(*,*)"FSOLVE STOP: number of calls to FCN has reached or exceeded 200*(N+1)."
  case(3)
     write(*,*)"FSOLVE STOP: TOL is too small. No further improvement to X is possible."
  case(4)
     write(*,*)"FSOLVE STOP: the iteration is not making good progress."
  end select
  stop
contains
  subroutine fsolve_hybrd1_func2sub(n,x,fvec,iflag)
    integer ::  n
    real(8) ::  x(n)
    real(8) ::  fvec(n)
    integer ::  iflag
    if(iflag==0)return
    fvec(:) = func(x)
    if(iflag<0)stop "FSOLVE_HYBRD1_func2sub ERROR: iflag < 0 "
  end subroutine fsolve_hybrd1_func2sub
end subroutine fsolve_hybrd_func
!
subroutine fsolve_hybrd_sub(func,x,tol,info)
  interface
     subroutine func(x,ff)
       real(8),dimension(:),intent(in) :: x
       real(8),dimension(size(x))      :: ff
     end subroutine func
  end interface
  real(8),dimension(:)       :: x      
  real(8),optional           :: tol
  integer,optional           :: info
  real(8)                    :: tol_
  integer                    :: info_
  integer                    :: n
  real(8),dimension(size(x)) :: fvec
  tol_ = 1.d-15;if(present(tol))tol_=tol
  n=size(x)
  call hybrd1(fsolve_hybrd1_sub2sub,n,x,fvec,tol_,info_)
  if(present(info))info=info_
  select case(info_)
  case default
     return
  case(0)
     write(*,*)"FSOLVE STOP: improper input parameters."
  case(1)
     write(*,*)"FSOLVE STOP: the relative error between X and the solution is at most TOL."
  case(2)
     write(*,*)"FSOLVE STOP: number of calls to FCN has reached or exceeded 200*(N+1)."
  case(3)
     write(*,*)"FSOLVE STOP: TOL is too small. No further improvement to X is possible."
  case(4)
     write(*,*)"FSOLVE STOP: the iteration is not making good progress."
  end select
  stop
contains
  subroutine fsolve_hybrd1_sub2sub(n,x,fvec,iflag)
    integer ::  n
    real(8) ::  x(n)
    real(8) ::  fvec(n)
    integer ::  iflag
    if(iflag==0)return
    call func(x,fvec)
    if(iflag<0)stop "FSOLVE_HYBRD1_sub2sub ERROR: iflag < 0 "
  end subroutine fsolve_hybrd1_sub2sub
end subroutine fsolve_hybrd_sub





!HYBRJ INTERFACE:
!solve N nonlinear equations in N unknowns
!user supplied analytic jacobian 
subroutine fsolve_hybrj_func(func,dfunc,x,tol,info)
  interface
     function func(x)
       real(8),dimension(:),intent(in) :: x
       real(8),dimension(size(x))      :: func
     end function func
     !
     function dfunc(x)
       real(8),dimension(:),intent(in)    :: x
       real(8),dimension(size(x),size(x)) :: dfunc
     end function dfunc
  end interface
  real(8),dimension(:)               :: x      
  real(8),optional                   :: tol
  integer,optional                   :: info
  real(8)                            :: tol_
  integer                            :: info_
  integer                            :: n
  real(8),dimension(size(x))         :: fvec
  real(8),dimension(size(x),size(x)) :: fjac
  tol_ = 1.d-15;if(present(tol))tol_=tol
  n=size(x)
  call hybrj1(fsolve_hybrj1_func2sub,n,x,fvec,fjac,n,tol_,info_)
  if(present(info))info=info_
  select case(info_)
  case default
     return
  case(0)
     write(*,*)"FSOLVE STOP: improper input parameters."
  case(1)
     write(*,*)"FSOLVE STOP: the relative error between X and the solution is at most TOL."
  case(2)
     write(*,*)"FSOLVE STOP: number of calls to FCN has reached or exceeded 200*(N+1)."
  case(3)
     write(*,*)"FSOLVE STOP: TOL is too small. No further improvement to X is possible."
  case(4)
     write(*,*)"FSOLVE STOP: the iteration is not making good progress."
  end select
  stop
contains
  subroutine fsolve_hybrj1_func2sub(n,x,fvec,fjac,ldfjac,iflag)
    integer ::  n
    real(8) ::  x(n)
    real(8) ::  fvec(n)
    integer ::  ldfjac
    real(8) ::  fjac(ldfjac,n)
    integer ::  iflag
    if(iflag==1)then
       fvec = func(x)
    elseif(iflag==2)then
       fjac = dfunc(x)
    endif
    if(iflag<0)stop "FSOLVE_HYBRJ1_func2sub ERROR: iflag < 0 "
  end subroutine fsolve_hybrj1_func2sub
end subroutine fsolve_hybrj_func
!
subroutine fsolve_hybrj_sub(func,dfunc,x,tol,info)
  interface
     subroutine func(x,f)
       real(8),dimension(:),intent(in) :: x
       real(8),dimension(size(x))      :: f
     end subroutine func
     !
     subroutine dfunc(x,df)
       real(8),dimension(:),intent(in)    :: x
       real(8),dimension(size(x),size(x)) :: df
     end subroutine dfunc
  end interface
  real(8),dimension(:)               :: x      
  real(8),optional                   :: tol
  integer,optional                   :: info
  real(8)                            :: tol_
  integer                            :: info_
  integer                            :: n
  real(8),dimension(size(x))         :: fvec
  real(8),dimension(size(x),size(x)) :: fjac
  tol_ = 1.d-15;if(present(tol))tol_=tol
  n=size(x)
  call hybrj1(fsolve_hybrj1_sub2sub,n,x,fvec,fjac,n,tol_,info_)
  if(present(info))info=info_
  select case(info_)
  case default
     return
  case(0)
     write(*,*)"FSOLVE STOP: improper input parameters."
  case(1)
     write(*,*)"FSOLVE STOP: the relative error between X and the solution is at most TOL."
  case(2)
     write(*,*)"FSOLVE STOP: number of calls to FCN has reached or exceeded 200*(N+1)."
  case(3)
     write(*,*)"FSOLVE STOP: TOL is too small. No further improvement to X is possible."
  case(4)
     write(*,*)"FSOLVE STOP: the iteration is not making good progress."
  end select
  stop
contains
  subroutine fsolve_hybrj1_sub2sub(n,x,fvec,fjac,ldfjac,iflag)
    integer ::  n
    real(8) ::  x(n)
    real(8) ::  fvec(n)
    integer ::  ldfjac
    real(8) ::  fjac(ldfjac,n)
    integer ::  iflag
    if(iflag==1)then
       call func(x,fvec)
    elseif(iflag==2)then
       call dfunc(x,fjac)
    endif
    if(iflag<0)stop "FSOLVE_HYBRJ1_sub2sub ERROR: iflag < 0 "
  end subroutine fsolve_hybrj1_sub2sub
end subroutine fsolve_hybrj_sub
