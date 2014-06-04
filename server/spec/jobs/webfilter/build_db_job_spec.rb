require 'spec_helper'

require 'jobs/webfilter/build_db_job'

module Sykus

  describe Webfilter::BuildDBJob do
    include FakeFS::SpecHelpers
    category_dir = Webfilter::BuildDBJob::CATEGORY_DIR
    out_dir = Webfilter::BuildDBJob::OUT_DIR

    let (:files) {%w{
      urls_black_students urls_black_all
      domains_white_all domains_white_nonstudents 
      domains_black_students domains_black_all
    }}

    before :each do
      FileUtils.mkdir_p category_dir

      Factory Webfilter::Category, 
        id: 1, name: 'bundle/cat1', selected: :none
      Factory Webfilter::Category, 
        id: 2, name: 'bundle/cat2', selected: :students
      Factory Webfilter::Category, 
        id: 3, name: 'bundle/cat3', selected: :all

      Factory Webfilter::Entry,
        domain: 'whiteall.com', type: :white_all 

      Factory Webfilter::Entry,
        domain: 'nonstudentsonly.com', type: :nonstudents_only 

      Factory Webfilter::Entry,
        domain: 'blackall.com', type: :black_all


      # these files get generated by system call, so fake them
      files.each do |file|
        FileUtils.touch "#{out_dir}/#{file}.tmp.db"
      end

      Webfilter::Category.all.each do |cat|
        FileUtils.mkdir_p "#{category_dir}/#{cat.name}"

          # add subdomains and 
          File.open("#{category_dir}/#{cat.name}/domains", 'w+') do |f|
          # base domain
          f.write "#{cat.id}.com\n"

        # subdomains that should get deleted
        f.write "sub.dom.#{cat.id}.com\n"
          f.write "sub.#{cat.id}.com\n"

          # subdomain that should stay
          f.write "sub.sub#{cat.id}.com\n"

        # invalid entries: blank lines and no dot in domain
        # (there was a bug where this caused an exception!)
        f.write "\n"
        f.write "  \n"
        f.write "invalidentry\n"
          end

        File.open("#{category_dir}/#{cat.name}/urls", 'w+') do |f|
          f.write "#{cat.id}.com/bad"
        end
      end
    end

    it 'updates the list dbs' do
      job = Webfilter::BuildDBJob

      job.should_receive(:system).once.with \
        'squidGuard -c /etc/squidguard/compile.conf -C all' do
        # check files before they get deleted
        File.read("#{out_dir}/domains_white_all.tmp").should == 
          "whiteall.com\n"

        File.read("#{out_dir}/domains_white_nonstudents.tmp").should == 
          "nonstudentsonly.com\n"

        File.read("#{out_dir}/domains_black_students.tmp").should == 
          "nonstudentsonly.com\n2.com\nsub.sub2.com\n"

        File.read("#{out_dir}/domains_black_all.tmp").should == 
          "blackall.com\n3.com\nsub.sub3.com\n"


        File.read("#{out_dir}/urls_black_students.tmp").should == 
          "2.com/bad\n"

        File.read("#{out_dir}/urls_black_all.tmp").should == 
          "3.com/bad\n"
        end

      job.should_receive(:system).once.with \
        "sudo chown proxy #{out_dir}/*.db"
      job.should_receive(:system).once.with 'sudo squid3 -k reconfigure'

      job.perform
    end
  end

end
