function! SubstrFromBuffer(start,end)
	let start=a:start
	let end=a:end
	let start[0]+=1
	if end[0]!=0
		let end[0]-=1
	endif
	let o=""
	for i in range(start[1],end[1])
		if i==start[1]
			let o.=getline(i)[start[0]:]
		elseif i==end[1]
			let o.=getline(i)[:end[0]]
		else
			let o.=getline(i)
		endif
	endfor
	return o
endfunction

"aint the best but eh, lgtm
function! ClosestIntegerMultiples(i)
	let i=a:i
	let a=1
	let b=1
	if i==0
		return [0,0]
	endif
	"calculates closest perfect square
	while i>=(a*b)
		let a+=1
		let b+=1
	endwhile
	let a-=1
	let b-=1
	"calculates closest smaller product
	while i>=(a*b)
		let a+=1
	endwhile
	let a-=1
	return [a,b]
endfunction

function! StartEndCursPos()
	"(x,y) because if you switch the coordinates you shouldnt be ever considered sane
	let start=[getpos("'<")[2],getpos("'<")[1]]
	let end=[getpos("'>")[2],getpos("'>")[1]]
	return [start,end]
	endfunction

"echo SubstrFromBuffer(start,end)

function! Text2Bf(s)
	let acc=0
	let s=a:s
	let c=""
	let second=v:false
	for i in s
		let t=ClosestIntegerMultiples(char2nr(i))
		let v=char2nr(i)
		let d=v-acc
		if d>0
			let dt=ClosestIntegerMultiples(d)
			if d>10
				if second
					let c.="<"
					let second=v:false
				endif
				for j in range(1,dt[1])
					let c.="+"
				endfor
				let c.="[>"
				for j in range(1,dt[0])
					let c.="+"
				endfor
				let c.="<-]>"
				"add  remaining addition
				for i in range(1,d-(dt[0]*dt[1]))
					let c.="+"
				endfor
				let c.="."
				let acc=v
				let second=v:true
			else
				"here i deemed that it would be cheaper to just put the pluses
				for i in range(1,(v-acc))
					let c.="+"
					let acc+=1
				endfor
				let c.="."
			endif
		else
			if -d<11
				if second==v:false
					let c.=">"
					let second=v:true
				endif
				while acc>v
					let c.="-"
					let acc-=1
				endwhile
				let c.="."
				let acc=v
			else
				if second
					let c.="<"
					let second=v:false
				endif
				let dt=ClosestIntegerMultiples(-d)
				for j in range(1,dt[1])
					let c.="+"
				endfor
				let c.="[>"
				for j in range(1,dt[0])
					let c.="-"
				endfor
				let c.="<-]>"
				let second=v:true
				for j in range(1,-d-(dt[0]*dt[1]))
					let c.="-"
				endfor
				let c.="."
				let acc=v
			endif
		endif
	endfor
	return c
endfunction

"echo Text2Bf("haii world :3 nyaa")

function! UwuifyText(t)
	let t=a:t
	let n=""
	for i in range(0,len(t)-1)
		if t[i]=="l" || t[i]=="r"
			let n.="w"
		elseif t[i]=="L" || t[i]=="R"
			let n.="W"
		else
			let n.=t[i]
		endif
	endfor
	let t=""
	for i in split(n," ")
		"da randomnezz
		let m=rand()
		let m=m/(pow(10,len(m)-2))-20
		if m<2
			let t.=" *blushes* "
		elseif m<5
			let t.=" nyaa "
		elseif m<7
			let t.=" uwu "
		elseif m<10
			let t.=" :3 "
		elseif m<11
			let t.=" ^^ "
		else
			let t.=" "
		endif
		let t.=i
	endfor
	return t
endfunction

function! PrintBfText()
	let c=StartEndCursPos()
	let t=SubstrFromBuffer(c[0],c[1])
	echo ""
	echo Text2Bf(t)
endfunction
function! PrintUwuifiedText()
	let c=StartEndCursPos()
	let t=SubstrFromBuffer(c[0],c[1])
	echo ""
	echo UwuifyText(t)
endfunction

command! PrintUwuified :call PrintUwuifiedText()
command! PrintBrainfuck :call PrintBfText()
