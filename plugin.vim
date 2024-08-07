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

"mkaes text harder to read
function! Obfuscate(w)
	let w=a:w
	let n=""
	for j in range(0,len(w)-1)
		let t=w[j]
		"generated for the purpose of randomization
		let r=rand()
		let r=r/pow(10,len(r))
		"swapping e's
		if t=="e" && j!=len(w)-1
			let n.=w[j+1]
			let n.="e"
			let j+=1
		elseif t=="s"
			"randomly swapping zs
			if r>=0.40
				let n.="z"
			else
				let n.="s"
			endif
		"doubling o's
		elseif t=="o" && j!=len(w)-1 && r>0.3
			let n.="oo"
			let j+=1
		else
			let n.=t
		endif
	endfor
	return n
endfunction

function! ToLowercase(m)
	let m=a:m
	let n=""
	for i in m
		if char2nr(i)>=65 && char2nr(i)<=90
			let n.=nr2char(char2nr(i)+32)
		else
			let n.=i
		endif
	endfor
	return n
endfunction

function! ToUppercase(m)
	let m=a:m
	let n=""
	for i in m
		if char2nr(i)>=97 && char2nr(i)<=122
			let n.=nr2char(char2nr(i)-32)
		else
			let n.=i
		endif
	endfor
	return n
endfunction

"weeee
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

function! Text2Deadfish(t)
	let t=a:t
	let c=""
	let acc=0
	for i in range(1,len(t)-1)
		let acc=str2nr(string(acc))
		let v=char2nr(t[i])
		"a simple optimalizrtion, basically handles using 's' without modulo
		if (acc*acc)<=v
			let c.="s"
			let acc*=acc
		endif
		while acc>v
			let c.="d"
			let acc-=1
		endwhile
		while acc<v
			let c.="i"
			let acc+=1
		endwhile
		let c.="o"
	endfor
	return c
endfunction

function! PrintBfText()
	let c=StartEndCursPos()
	let t=SubstrFromBuffer(c[0],c[1])
	echo " "
	echo Text2Bf(t)
endfunction
function! PrintUwuifiedText()
	let c=StartEndCursPos()
	let t=SubstrFromBuffer(c[0],c[1])
	echo " "
	echo UwuifyText(t)
endfunction

command! PrintUwuified :call PrintUwuifiedText()
command! PrintBrainfuck :call PrintBfText()

function! Lolcat(s)
	let s=ToLowercase(a:s)
	let s=split(s," ")
	let n=""
	let next=v:true
	for i in range(0,len(s)-1)
		if next
			if i!=len(s)-2 && s[i]=="can" && s[i+1]=="i"
				let n.="i can "
				let next=v:false
			elseif s[i]=="your"
				let n.="ur "
			elseif s[i]=="matter"
				let n.="mattr "
			elseif s[i]=="to"
				let n.="2 "
			elseif s[i]=="have"
				let n.="has "
			elseif s[i]!="a" && s[i]!="and"
				let t=Obfuscate(s[i])
				let n.=t." "
			endif
		else
			let next=v:true
		endif
	endfor
	return ToUppercase(n)
endfunction

function! Leet(n)
	let n=a:n
	let o=""
	for i in n
		if ToLowercase(i)=='a'
			let o.='4'
		elseif ToLowercase(i)=='o'
			let o.='0'
		elseif ToLowercase(i)=='e'
			let o.='3'
		elseif ToLowercase(i)=="l" || ToLowercase(i)=="i"
			let o.='1'
		elseif ToLowercase(i)=='t'
			let o.='7'
		elseif ToLowercase(i)=='s'
			let o.='5'
		else
			let o.=i
		endif
	endfor
	return o
endfunction
