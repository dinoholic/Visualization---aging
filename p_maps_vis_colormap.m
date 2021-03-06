dir_data = '/Users/george/Desktop/Vis_aging/';
dir_measure = {'pair';'tree'};
dir_pmaps = {'_decliner_v_gainer';'_decliner_v_gainer,neither';'_decliner_v_neither'};

p_val = .05;

for ind_measure = 1%:2
    for ind_pmap = 1%:3
    %%

%         vol_t1 = MRIread([dir_data 'brain_t1_in_mni.nii.gz']);
        vol_pmap = MRIread([dir_data dir_measure{ind_measure} dir_pmaps{ind_pmap} '.nii.gz']);
        
        vol_pmap.vol(:,:,1:3) = 0;
        
        vol_t1.vol = zeros(size(vol_pmap.vol));
        vol_t1.vol(find(vol_pmap.vol)) = 1;
%%
        vol_t1s = smooth3(vol_t1.vol);
        close
        hcap = patch(isosurface(vol_t1s,0.02),...
        'FaceColor',[.9,1,1],...
        'EdgeColor','none','FaceAlpha',.2);
    
        unique_p_vals = unique(vol_pmap.vol);
        unique_p_vals = unique_p_vals(find(unique(vol_pmap.vol) < .05));
        unique_p_vals(find(unique_p_vals==0)) = '';
        p_lev = (p_val - unique_p_vals)/p_val;
    %%
        for lev = 1:numel(unique_p_vals)
%%
            vol_p_reg = zeros(size(vol_pmap.vol));
%             ind_vec_pmin = setdiff( find(vol_pmap.vol <= p_val), find(vol_pmap.vol == 0) );    
            ind_vec_pmin = find(vol_pmap.vol == unique_p_vals(lev));
            vol_p_reg(ind_vec_pmin) = 1;
        %     vol3d('cdata',vol_p_regs);
            vol_p_regs = smooth3(vol_p_reg);
            
            hiso = patch(isosurface(vol_p_regs,0.02),...
                'FaceColor',[1,p_lev(lev),0],...
                'EdgeColor','none','FaceAlpha',1);
            set(hiso,'AmbientStrength',.6)
            set(hiso,'SpecularColorReflectance',0,'SpecularExponent',5)
        end
        %%
        lighting GOURAUD
    %     set(gca,'color',[1,1,1]);
        lightangle(45,10);
        lightangle(260,-20);
%         daspect(1./vol_t1.volres)
        daspect([1 1 1])
        view(140,15)
    %     view(140,45)
        % view(140,55)
        axis tight
    %     zoom(1.5)
        set(gca,'Visible','off')

%         view(0,-90)
%         saveas(gca,sprintf('%svis_%s_%s_bottom.png',dir_data,dir_measure{ind_measure},dir_pmaps{ind_pmap}))
%         view(180,0)
%         saveas(gca,sprintf('%svis_%s_%s_front.png',dir_data,dir_measure{ind_measure},dir_pmaps{ind_pmap}))
%         view(90,0)
%         saveas(gca,sprintf('%svis_%s_%s_side.png',dir_data,dir_measure{ind_measure},dir_pmaps{ind_pmap}))
%         fig_rotate_save(1,sprintf('%sglass_brain_%s%s',dir_data,dir_measure{ind_measure},dir_pmaps{ind_pmap}))

    end
end