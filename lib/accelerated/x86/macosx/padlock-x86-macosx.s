/*
# Copyright (c) 2011-2012, Andy Polyakov <appro@openssl.org>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
#     * Redistributions of source code must retain copyright notices,
#      this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials
#      provided with the distribution.
#
#     * Neither the name of the Andy Polyakov nor the names of its
#      copyright holder and contributors may be used to endorse or
#      promote products derived from this software without specific
#      prior written permission.
#
# ALTERNATIVELY, provided that this notice is retained in full, this
# product may be distributed under the terms of the GNU General Public
# License (GPL), in which case the provisions of the GPL apply INSTEAD OF
# those given above.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# *** This file is auto-generated ***
#
*/
.file	"devel/perlasm/e_padlock-x86.s"
.text
.globl	_padlock_capability
.align	4
_padlock_capability:
L_padlock_capability_begin:
	pushl	%ebx
	pushfl
	popl	%eax
	movl	%eax,%ecx
	xorl	$2097152,%eax
	pushl	%eax
	popfl
	pushfl
	popl	%eax
	xorl	%eax,%ecx
	xorl	%eax,%eax
	btl	$21,%ecx
	jnc	L000noluck
	.byte	0x0f,0xa2
	xorl	%eax,%eax
	cmpl	$0x746e6543,%ebx
	jne	L000noluck
	cmpl	$0x48727561,%edx
	jne	L000noluck
	cmpl	$0x736c7561,%ecx
	jne	L000noluck
	movl	$3221225472,%eax
	.byte	0x0f,0xa2
	movl	%eax,%edx
	xorl	%eax,%eax
	cmpl	$3221225473,%edx
	jb	L000noluck
	movl	$1,%eax
	.byte	0x0f,0xa2
	orl	$15,%eax
	xorl	%ebx,%ebx
	andl	$4095,%eax
	cmpl	$1791,%eax
	sete	%bl
	movl	$3221225473,%eax
	pushl	%ebx
	.byte	0x0f,0xa2
	popl	%ebx
	movl	%edx,%eax
	shll	$4,%ebx
	andl	$4294967279,%eax
	orl	%ebx,%eax
L000noluck:
	popl	%ebx
	ret
.globl	_padlock_key_bswap
.align	4
_padlock_key_bswap:
L_padlock_key_bswap_begin:
	movl	4(%esp),%edx
	movl	240(%edx),%ecx
L001bswap_loop:
	movl	(%edx),%eax
	bswap	%eax
	movl	%eax,(%edx)
	leal	4(%edx),%edx
	subl	$1,%ecx
	jnz	L001bswap_loop
	ret
.globl	_padlock_verify_context
.align	4
_padlock_verify_context:
L_padlock_verify_context_begin:
	movl	4(%esp),%edx
	leal	Lpadlock_saved_context-L002verify_pic_point,%eax
	pushfl
	call	__padlock_verify_ctx
L002verify_pic_point:
	leal	4(%esp),%esp
	ret
.align	4
__padlock_verify_ctx:
	addl	(%esp),%eax
	btl	$30,4(%esp)
	jnc	L003verified
	cmpl	(%eax),%edx
	je	L003verified
	pushfl
	popfl
L003verified:
	movl	%edx,(%eax)
	ret
.globl	_padlock_reload_key
.align	4
_padlock_reload_key:
L_padlock_reload_key_begin:
	pushfl
	popfl
	ret
.globl	_padlock_aes_block
.align	4
_padlock_aes_block:
L_padlock_aes_block_begin:
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	movl	16(%esp),%edi
	movl	20(%esp),%esi
	movl	24(%esp),%edx
	movl	$1,%ecx
	leal	32(%edx),%ebx
	leal	16(%edx),%edx
.byte	243,15,167,200
	popl	%ebx
	popl	%esi
	popl	%edi
	ret
.globl	_padlock_ecb_encrypt
.align	4
_padlock_ecb_encrypt:
L_padlock_ecb_encrypt_begin:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	20(%esp),%edi
	movl	24(%esp),%esi
	movl	28(%esp),%edx
	movl	32(%esp),%ecx
	testl	$15,%edx
	jnz	L004ecb_abort
	testl	$15,%ecx
	jnz	L004ecb_abort
	leal	Lpadlock_saved_context-L005ecb_pic_point,%eax
	pushfl
	cld
	call	__padlock_verify_ctx
L005ecb_pic_point:
	leal	16(%edx),%edx
	xorl	%eax,%eax
	xorl	%ebx,%ebx
	testl	$32,(%edx)
	jnz	L006ecb_aligned
	testl	$15,%edi
	setz	%al
	testl	$15,%esi
	setz	%bl
	testl	%ebx,%eax
	jnz	L006ecb_aligned
	negl	%eax
	movl	$512,%ebx
	notl	%eax
	leal	-24(%esp),%ebp
	cmpl	%ebx,%ecx
	cmovcl	%ecx,%ebx
	andl	%ebx,%eax
	movl	%ecx,%ebx
	negl	%eax
	andl	$511,%ebx
	leal	(%eax,%ebp,1),%esp
	movl	$512,%eax
	cmovzl	%eax,%ebx
	movl	%ebp,%eax
	andl	$-16,%ebp
	andl	$-16,%esp
	movl	%eax,16(%ebp)
	cmpl	%ebx,%ecx
	ja	L007ecb_loop
	movl	%esi,%eax
	cmpl	%esp,%ebp
	cmovel	%edi,%eax
	addl	%ecx,%eax
	negl	%eax
	andl	$4095,%eax
	cmpl	$128,%eax
	movl	$-128,%eax
	cmovael	%ebx,%eax
	andl	%eax,%ebx
	jz	L008ecb_unaligned_tail
	jmp	L007ecb_loop
.align	4,0x90
L007ecb_loop:
	movl	%edi,(%ebp)
	movl	%esi,4(%ebp)
	movl	%ecx,8(%ebp)
	movl	%ebx,%ecx
	movl	%ebx,12(%ebp)
	testl	$15,%edi
	cmovnzl	%esp,%edi
	testl	$15,%esi
	jz	L009ecb_inp_aligned
	shrl	$2,%ecx
.byte	243,165
	subl	%ebx,%edi
	movl	%ebx,%ecx
	movl	%edi,%esi
L009ecb_inp_aligned:
	leal	-16(%edx),%eax
	leal	16(%edx),%ebx
	shrl	$4,%ecx
.byte	243,15,167,200
	movl	(%ebp),%edi
	movl	12(%ebp),%ebx
	testl	$15,%edi
	jz	L010ecb_out_aligned
	movl	%ebx,%ecx
	leal	(%esp),%esi
	shrl	$2,%ecx
.byte	243,165
	subl	%ebx,%edi
L010ecb_out_aligned:
	movl	4(%ebp),%esi
	movl	8(%ebp),%ecx
	addl	%ebx,%edi
	addl	%ebx,%esi
	subl	%ebx,%ecx
	movl	$512,%ebx
	jz	L011ecb_break
	cmpl	%ebx,%ecx
	jae	L007ecb_loop
L008ecb_unaligned_tail:
	xorl	%eax,%eax
	cmpl	%ebp,%esp
	cmovel	%ecx,%eax
	subl	%eax,%esp
	movl	%edi,%eax
	movl	%ecx,%ebx
	shrl	$2,%ecx
	leal	(%esp),%edi
.byte	243,165
	movl	%esp,%esi
	movl	%eax,%edi
	movl	%ebx,%ecx
	jmp	L007ecb_loop
.align	4,0x90
L011ecb_break:
	cmpl	%ebp,%esp
	je	L012ecb_done
	pxor	%xmm0,%xmm0
	leal	(%esp),%eax
L013ecb_bzero:
	movaps	%xmm0,(%eax)
	leal	16(%eax),%eax
	cmpl	%eax,%ebp
	ja	L013ecb_bzero
L012ecb_done:
	movl	16(%ebp),%ebp
	leal	24(%ebp),%esp
	jmp	L014ecb_exit
.align	4,0x90
L006ecb_aligned:
	leal	(%esi,%ecx,1),%ebp
	negl	%ebp
	andl	$4095,%ebp
	xorl	%eax,%eax
	cmpl	$128,%ebp
	movl	$127,%ebp
	cmovael	%eax,%ebp
	andl	%ecx,%ebp
	subl	%ebp,%ecx
	jz	L015ecb_aligned_tail
	leal	-16(%edx),%eax
	leal	16(%edx),%ebx
	shrl	$4,%ecx
.byte	243,15,167,200
	testl	%ebp,%ebp
	jz	L014ecb_exit
L015ecb_aligned_tail:
	movl	%ebp,%ecx
	leal	-24(%esp),%ebp
	movl	%ebp,%esp
	movl	%ebp,%eax
	subl	%ecx,%esp
	andl	$-16,%ebp
	andl	$-16,%esp
	movl	%eax,16(%ebp)
	movl	%edi,%eax
	movl	%ecx,%ebx
	shrl	$2,%ecx
	leal	(%esp),%edi
.byte	243,165
	movl	%esp,%esi
	movl	%eax,%edi
	movl	%ebx,%ecx
	jmp	L007ecb_loop
L014ecb_exit:
	movl	$1,%eax
	leal	4(%esp),%esp
L004ecb_abort:
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.globl	_padlock_cbc_encrypt
.align	4
_padlock_cbc_encrypt:
L_padlock_cbc_encrypt_begin:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	20(%esp),%edi
	movl	24(%esp),%esi
	movl	28(%esp),%edx
	movl	32(%esp),%ecx
	testl	$15,%edx
	jnz	L016cbc_abort
	testl	$15,%ecx
	jnz	L016cbc_abort
	leal	Lpadlock_saved_context-L017cbc_pic_point,%eax
	pushfl
	cld
	call	__padlock_verify_ctx
L017cbc_pic_point:
	leal	16(%edx),%edx
	xorl	%eax,%eax
	xorl	%ebx,%ebx
	testl	$32,(%edx)
	jnz	L018cbc_aligned
	testl	$15,%edi
	setz	%al
	testl	$15,%esi
	setz	%bl
	testl	%ebx,%eax
	jnz	L018cbc_aligned
	negl	%eax
	movl	$512,%ebx
	notl	%eax
	leal	-24(%esp),%ebp
	cmpl	%ebx,%ecx
	cmovcl	%ecx,%ebx
	andl	%ebx,%eax
	movl	%ecx,%ebx
	negl	%eax
	andl	$511,%ebx
	leal	(%eax,%ebp,1),%esp
	movl	$512,%eax
	cmovzl	%eax,%ebx
	movl	%ebp,%eax
	andl	$-16,%ebp
	andl	$-16,%esp
	movl	%eax,16(%ebp)
	cmpl	%ebx,%ecx
	ja	L019cbc_loop
	movl	%esi,%eax
	cmpl	%esp,%ebp
	cmovel	%edi,%eax
	addl	%ecx,%eax
	negl	%eax
	andl	$4095,%eax
	cmpl	$64,%eax
	movl	$-64,%eax
	cmovael	%ebx,%eax
	andl	%eax,%ebx
	jz	L020cbc_unaligned_tail
	jmp	L019cbc_loop
.align	4,0x90
L019cbc_loop:
	movl	%edi,(%ebp)
	movl	%esi,4(%ebp)
	movl	%ecx,8(%ebp)
	movl	%ebx,%ecx
	movl	%ebx,12(%ebp)
	testl	$15,%edi
	cmovnzl	%esp,%edi
	testl	$15,%esi
	jz	L021cbc_inp_aligned
	shrl	$2,%ecx
.byte	243,165
	subl	%ebx,%edi
	movl	%ebx,%ecx
	movl	%edi,%esi
L021cbc_inp_aligned:
	leal	-16(%edx),%eax
	leal	16(%edx),%ebx
	shrl	$4,%ecx
.byte	243,15,167,208
	movaps	(%eax),%xmm0
	movaps	%xmm0,-16(%edx)
	movl	(%ebp),%edi
	movl	12(%ebp),%ebx
	testl	$15,%edi
	jz	L022cbc_out_aligned
	movl	%ebx,%ecx
	leal	(%esp),%esi
	shrl	$2,%ecx
.byte	243,165
	subl	%ebx,%edi
L022cbc_out_aligned:
	movl	4(%ebp),%esi
	movl	8(%ebp),%ecx
	addl	%ebx,%edi
	addl	%ebx,%esi
	subl	%ebx,%ecx
	movl	$512,%ebx
	jz	L023cbc_break
	cmpl	%ebx,%ecx
	jae	L019cbc_loop
L020cbc_unaligned_tail:
	xorl	%eax,%eax
	cmpl	%ebp,%esp
	cmovel	%ecx,%eax
	subl	%eax,%esp
	movl	%edi,%eax
	movl	%ecx,%ebx
	shrl	$2,%ecx
	leal	(%esp),%edi
.byte	243,165
	movl	%esp,%esi
	movl	%eax,%edi
	movl	%ebx,%ecx
	jmp	L019cbc_loop
.align	4,0x90
L023cbc_break:
	cmpl	%ebp,%esp
	je	L024cbc_done
	pxor	%xmm0,%xmm0
	leal	(%esp),%eax
L025cbc_bzero:
	movaps	%xmm0,(%eax)
	leal	16(%eax),%eax
	cmpl	%eax,%ebp
	ja	L025cbc_bzero
L024cbc_done:
	movl	16(%ebp),%ebp
	leal	24(%ebp),%esp
	jmp	L026cbc_exit
.align	4,0x90
L018cbc_aligned:
	leal	(%esi,%ecx,1),%ebp
	negl	%ebp
	andl	$4095,%ebp
	xorl	%eax,%eax
	cmpl	$64,%ebp
	movl	$63,%ebp
	cmovael	%eax,%ebp
	andl	%ecx,%ebp
	subl	%ebp,%ecx
	jz	L027cbc_aligned_tail
	leal	-16(%edx),%eax
	leal	16(%edx),%ebx
	shrl	$4,%ecx
.byte	243,15,167,208
	movaps	(%eax),%xmm0
	movaps	%xmm0,-16(%edx)
	testl	%ebp,%ebp
	jz	L026cbc_exit
L027cbc_aligned_tail:
	movl	%ebp,%ecx
	leal	-24(%esp),%ebp
	movl	%ebp,%esp
	movl	%ebp,%eax
	subl	%ecx,%esp
	andl	$-16,%ebp
	andl	$-16,%esp
	movl	%eax,16(%ebp)
	movl	%edi,%eax
	movl	%ecx,%ebx
	shrl	$2,%ecx
	leal	(%esp),%edi
.byte	243,165
	movl	%esp,%esi
	movl	%eax,%edi
	movl	%ebx,%ecx
	jmp	L019cbc_loop
L026cbc_exit:
	movl	$1,%eax
	leal	4(%esp),%esp
L016cbc_abort:
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.globl	_padlock_xstore
.align	4
_padlock_xstore:
L_padlock_xstore_begin:
	pushl	%edi
	movl	8(%esp),%edi
	movl	12(%esp),%edx
.byte	15,167,192
	popl	%edi
	ret
.align	4
__win32_segv_handler:
	movl	$1,%eax
	movl	4(%esp),%edx
	movl	12(%esp),%ecx
	cmpl	$3221225477,(%edx)
	jne	L028ret
	addl	$4,184(%ecx)
	movl	$0,%eax
L028ret:
	ret
.globl	_padlock_sha1_oneshot
.align	4
_padlock_sha1_oneshot:
L_padlock_sha1_oneshot_begin:
	pushl	%edi
	pushl	%esi
	xorl	%eax,%eax
	movl	12(%esp),%edi
	movl	16(%esp),%esi
	movl	20(%esp),%ecx
	movl	%esp,%edx
	addl	$-128,%esp
	movups	(%edi),%xmm0
	andl	$-16,%esp
	movl	16(%edi),%eax
	movaps	%xmm0,(%esp)
	movl	%esp,%edi
	movl	%eax,16(%esp)
	xorl	%eax,%eax
.byte	243,15,166,200
	movaps	(%esp),%xmm0
	movl	16(%esp),%eax
	movl	%edx,%esp
	movl	12(%esp),%edi
	movups	%xmm0,(%edi)
	movl	%eax,16(%edi)
	popl	%esi
	popl	%edi
	ret
.globl	_padlock_sha1_blocks
.align	4
_padlock_sha1_blocks:
L_padlock_sha1_blocks_begin:
	pushl	%edi
	pushl	%esi
	movl	12(%esp),%edi
	movl	16(%esp),%esi
	movl	%esp,%edx
	movl	20(%esp),%ecx
	addl	$-128,%esp
	movups	(%edi),%xmm0
	andl	$-16,%esp
	movl	16(%edi),%eax
	movaps	%xmm0,(%esp)
	movl	%esp,%edi
	movl	%eax,16(%esp)
	movl	$-1,%eax
.byte	243,15,166,200
	movaps	(%esp),%xmm0
	movl	16(%esp),%eax
	movl	%edx,%esp
	movl	12(%esp),%edi
	movups	%xmm0,(%edi)
	movl	%eax,16(%edi)
	popl	%esi
	popl	%edi
	ret
.globl	_padlock_sha256_oneshot
.align	4
_padlock_sha256_oneshot:
L_padlock_sha256_oneshot_begin:
	pushl	%edi
	pushl	%esi
	xorl	%eax,%eax
	movl	12(%esp),%edi
	movl	16(%esp),%esi
	movl	20(%esp),%ecx
	movl	%esp,%edx
	addl	$-128,%esp
	movups	(%edi),%xmm0
	andl	$-16,%esp
	movups	16(%edi),%xmm1
	movaps	%xmm0,(%esp)
	movl	%esp,%edi
	movaps	%xmm1,16(%esp)
	xorl	%eax,%eax
.byte	243,15,166,208
	movaps	(%esp),%xmm0
	movaps	16(%esp),%xmm1
	movl	%edx,%esp
	movl	12(%esp),%edi
	movups	%xmm0,(%edi)
	movups	%xmm1,16(%edi)
	popl	%esi
	popl	%edi
	ret
.globl	_padlock_sha256_blocks
.align	4
_padlock_sha256_blocks:
L_padlock_sha256_blocks_begin:
	pushl	%edi
	pushl	%esi
	movl	12(%esp),%edi
	movl	16(%esp),%esi
	movl	20(%esp),%ecx
	movl	%esp,%edx
	addl	$-128,%esp
	movups	(%edi),%xmm0
	andl	$-16,%esp
	movups	16(%edi),%xmm1
	movaps	%xmm0,(%esp)
	movl	%esp,%edi
	movaps	%xmm1,16(%esp)
	movl	$-1,%eax
.byte	243,15,166,208
	movaps	(%esp),%xmm0
	movaps	16(%esp),%xmm1
	movl	%edx,%esp
	movl	12(%esp),%edi
	movups	%xmm0,(%edi)
	movups	%xmm1,16(%edi)
	popl	%esi
	popl	%edi
	ret
.globl	_padlock_sha512_blocks
.align	4
_padlock_sha512_blocks:
L_padlock_sha512_blocks_begin:
	pushl	%edi
	pushl	%esi
	movl	12(%esp),%edi
	movl	16(%esp),%esi
	movl	20(%esp),%ecx
	movl	%esp,%edx
	addl	$-128,%esp
	movups	(%edi),%xmm0
	andl	$-16,%esp
	movups	16(%edi),%xmm1
	movups	32(%edi),%xmm2
	movups	48(%edi),%xmm3
	movaps	%xmm0,(%esp)
	movl	%esp,%edi
	movaps	%xmm1,16(%esp)
	movaps	%xmm2,32(%esp)
	movaps	%xmm3,48(%esp)
.byte	243,15,166,224
	movaps	(%esp),%xmm0
	movaps	16(%esp),%xmm1
	movaps	32(%esp),%xmm2
	movaps	48(%esp),%xmm3
	movl	%edx,%esp
	movl	12(%esp),%edi
	movups	%xmm0,(%edi)
	movups	%xmm1,16(%edi)
	movups	%xmm2,32(%edi)
	movups	%xmm3,48(%edi)
	popl	%esi
	popl	%edi
	ret
.byte	86,73,65,32,80,97,100,108,111,99,107,32,120,56,54,32
.byte	109,111,100,117,108,101,44,32,67,82,89,80,84,79,71,65
.byte	77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101
.byte	110,115,115,108,46,111,114,103,62,0
.align	4,0x90
.data
.align	2,0x90
Lpadlock_saved_context:
.long	0
